class_name DiceDomain
extends Node

## v5.0 DiceDomain - Manages Weighted Rolls & Modifier Generation
## Responsibility: roll_d20(), _resolve_category(), generate_modifier().
## Constraint: Uses GameRNG (randi/randf), no internal state storage.

func _ready() -> void:
	EventBus.dice_roll_requested.connect(_on_dice_roll_requested)

func _on_dice_roll_requested(context: DiceContext) -> void:
	roll_for_context(context)

func roll_for_context(context: DiceContext) -> DiceRollResult:
	var raw := _roll_d20()
	var cat := _resolve_category(raw, context.luck_value)
	var mod := _pick_modifier(cat, context.context_type)
	
	var result := DiceRollResult.new()
	result.raw_roll = raw
	result.category = cat
	result.modifier = mod
	result.context = context
	
	print("[DiceDomain] Rolled %d, Category: %d, Modifier: %s" % [raw, cat, mod.name])
	
	EventBus.dice_roll_completed.emit(result)
	EventBus.dice_modifier_generated.emit(mod)
	return result

func _roll_d20() -> int:
	return (randi() % 20) + 1

func _resolve_category(_roll: int, luck: float) -> int:
	# v5.0 Formula: Luck shifts weights, doesn't change raw value directly
	var weights := _get_weights(luck)
	# Weights: [MajNeg:0, MinNeg:1, Neu:2, MinPos:3, MajPos:4]
	
	var total_weight := 0.0
	for w in weights:
		total_weight += w
	
	var r := randf() * total_weight
	var cumulative := 0.0
	for i in range(weights.size()):
		cumulative += weights[i]
		if r <= cumulative:
			return i
	
	return 2 # Default to NEUTRAL

func _get_weights(luck: float) -> Array[float]:
	# v5.0 luck_shift = luck_stat * 0.6
	var shift := luck * 0.6
	return [
		maxf(2.0, 20.0 - shift * 0.7), # MAJOR_NEG (Base 20)
		maxf(5.0, 20.0 - shift * 0.3), # MINOR_NEG (Base 20)
		10.0,                          # NEUTRAL (Base 10)
		25.0 + shift * 0.4,            # MINOR_POS (Base 25)
		25.0 + shift * 0.6             # MAJOR_POS (Base 25)
	]

func _pick_modifier(category: int, _context_type: int) -> RunModifier:
	# Modifier Table (Simplified for Sprint 1/4 transition)
	# v5.0 Rule: Modifier impact ±15-25%
	var mod := RunModifier.new()
	match category:
		0: # MAJOR_NEG
			mod.name = "Dark Omen"
			mod.damage_bonus = -0.20
			mod.description = "-20% Damage, +15% Enemy Damage"
			mod.enemy_hp_multiplier = 1.15
		1: # MINOR_NEG
			mod.name = "Cursed Path"
			mod.damage_bonus = -0.10
			mod.description = "-10% Gold Gain, +10% Enemy HP"
			mod.gold_gain_bonus = -0.10
			mod.enemy_hp_multiplier = 1.10
		2: # NEUTRAL
			mod.name = "Steady Hand"
			mod.damage_bonus = 0.0
			mod.description = "No Effect"
		3: # MINOR_POS
			mod.name = "Sharp Eye"
			mod.damage_bonus = 0.10
			mod.description = "+10% Crit, +8% Damage"
		4: # MAJOR_POS
			mod.name = "War Fury"
			mod.damage_bonus = 0.20
			mod.description = "+20% Damage, +15% Attack Speed"
			mod.attack_speed_bonus = 0.15
	return mod
