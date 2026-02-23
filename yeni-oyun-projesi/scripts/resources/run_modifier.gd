class_name RunModifier
extends Resource

## v5.0 RunModifier - Represents a run-level modifier
## Applied to damage, enemy hp, loot, etc.
## Constraint: Maximum ±25% impact as per DICE-02.

@export var name: String = "Unknown Modifier"
@export var description: String = ""

# Modifier values (±25% limits as per DICE-02)
@export var damage_bonus: float = 0.0
@export var attack_speed_bonus: float = 0.0
@export var movement_speed_bonus: float = 0.0
@export var enemy_hp_multiplier: float = 1.0
@export var loot_rarity_bonus: float = 0.0
@export var gold_gain_bonus: float = 0.0

static func create(p_name: String, p_damage: float = 0.0, p_desc: String = "") -> RunModifier:
	var mod := RunModifier.new()
	mod.name = p_name
	mod.damage_bonus = clampf(p_damage, -0.25, 0.25)
	mod.description = p_desc
	return mod
