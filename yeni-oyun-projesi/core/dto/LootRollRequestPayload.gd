class_name LootRollRequestPayload
extends RefCounted

## Loot roll request event payload
## Used when loot roll is requested

var loot_table_id: String
var luck_modifier: float

func _init(p_loot_table_id: String, p_luck_modifier: float) -> void:
	assert(p_loot_table_id != "", "Loot table ID cannot be empty")
	assert(!is_nan(p_luck_modifier), "Luck modifier cannot be NaN")
	
	loot_table_id = p_loot_table_id
	luck_modifier = p_luck_modifier