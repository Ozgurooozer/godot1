class_name StoredDicePayload
extends RefCounted

## Stored dice event payload
## Used when stored dice are added or used

var dice_value: int
var stored_count: int
var max_stored: int

func _init(p_dice_value: int, p_stored_count: int, p_max_stored: int) -> void:
	assert(p_dice_value >= 1 and p_dice_value <= 20, "Dice value must be 1-20")
	assert(p_stored_count >= 0, "Stored count cannot be negative")
	assert(p_max_stored > 0, "Max stored must be positive")
	assert(p_stored_count <= p_max_stored, "Stored count cannot exceed max")
	
	dice_value = p_dice_value
	stored_count = p_stored_count
	max_stored = p_max_stored