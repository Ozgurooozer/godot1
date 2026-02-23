class_name DamagePayload
extends RefCounted

## Damage application event payload
## Used when damage is applied to target

var target: String
var final_damage: int
var is_critical: bool

func _init(p_target: String, p_final_damage: int, p_is_critical: bool) -> void:
	assert(p_target != "", "Target cannot be empty")
	assert(p_final_damage >= 0, "Damage cannot be negative")
	
	target = p_target
	final_damage = p_final_damage
	is_critical = p_is_critical