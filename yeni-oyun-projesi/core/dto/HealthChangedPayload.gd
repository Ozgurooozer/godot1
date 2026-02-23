class_name HealthChangedPayload
extends RefCounted

## Health change event payload
## Used when player or entity health changes

var new_health: int
var max_health: int
var source: String

func _init(p_new_health: int, p_max_health: int, p_source: String) -> void:
	assert(p_new_health >= 0, "Health cannot be negative")
	assert(p_max_health > 0, "Max health must be positive")
	assert(p_source != "", "Source cannot be empty")
	
	new_health = p_new_health
	max_health = p_max_health
	source = p_source