class_name DamageRequestPayload
extends RefCounted

## Damage request event payload
## Used when damage calculation is requested

var target: String
var base_damage: int
var damage_type: String

func _init(p_target: String, p_base_damage: int, p_damage_type: String) -> void:
	assert(p_target != "", "Target cannot be empty")
	assert(p_base_damage >= 0, "Base damage cannot be negative")
	assert(p_damage_type != "", "Damage type cannot be empty")
	
	target = p_target
	base_damage = p_base_damage
	damage_type = p_damage_type