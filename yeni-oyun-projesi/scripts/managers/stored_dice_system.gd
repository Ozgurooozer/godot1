class_name StoredDiceSystem
extends Node

## v5.0 StoredDiceSystem - Manages drop and consumption of stored dice
## Constraint: Max 3 stored dice, roll right is stored, not result.

const MAX_STORED: int = 3
const BASE_DROP: float = 0.15

func _ready() -> void:
	EventBus.dice_stored_consumed.connect(_on_stored_consumed)

func try_drop_dice(luck: float) -> void:
	var run_domain = GameManager.instance.run_domain
	if not run_domain or not run_domain.run_state:
		return
		
	var run_state: RunState = run_domain.run_state
	if run_state.stored_dice_list.size() >= MAX_STORED:
		return
	
	# v5.0 Drop Chance: Base 15% + luck * 0.013
	var drop_chance: float = BASE_DROP + luck * 0.013
	if randf() < drop_chance:
		var dice: Resource = load("res://scripts/resources/stored_dice.gd").new()
		run_state.stored_dice_list.append(dice)
		EventBus.dice_stored_added.emit(dice)
		print("[StoredDiceSystem] Dropped new dice! Total: ", run_state.stored_dice_list.size())

func _on_stored_consumed(dice: Resource, context_type: StringName) -> void:
	var run_domain = GameManager.instance.run_domain
	if not run_domain or not run_domain.run_state:
		return
		
	var run_state: RunState = run_domain.run_state
	run_state.stored_dice_list.erase(dice)
	print("[StoredDiceSystem] Consumed dice for context: ", context_type)
