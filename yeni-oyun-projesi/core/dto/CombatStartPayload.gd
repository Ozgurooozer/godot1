extends RefCounted
class_name CombatStartPayload

## Combat start event payload
## Used when combat encounter begins

var initial_combat_seed: int

func _init(p_initial_combat_seed: int) -> void:
	assert(p_initial_combat_seed != 0, "Combat seed cannot be 0")
	initial_combat_seed = p_initial_combat_seed