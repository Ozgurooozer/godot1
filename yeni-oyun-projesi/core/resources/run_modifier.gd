class_name RunModifier
extends Resource

## RunModifier Resource
## Represents a run-level modifier generated from dice roll category
## Stored in RunState and applied during combat/loot calculations

@export var damage_multiplier: float = 1.0
@export var damage_modifier_pct: float = 0.0
@export var enemy_hp_multiplier: float = 1.0
@export var loot_multiplier: float = 1.0
@export var description: String = ""

## Create a new RunModifier with specified values
static func create(
	p_damage_mult: float,
	p_enemy_hp_mult: float,
	p_loot_mult: float,
	p_description: String
) -> RunModifier:
	var modifier := RunModifier.new()
	modifier.damage_multiplier = p_damage_mult
	modifier.enemy_hp_multiplier = p_enemy_hp_mult
	modifier.loot_multiplier = p_loot_mult
	modifier.description = p_description
	return modifier
