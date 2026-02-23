class_name LootRollResultPayload
extends RefCounted

## Loot roll result event payload
## Used when loot roll result is available

var item_id: String
var item_name: String
var rarity: String

func _init(p_item_id: String, p_item_name: String, p_rarity: String) -> void:
	assert(p_item_id != "", "Item ID cannot be empty")
	assert(p_item_name != "", "Item name cannot be empty")
	assert(p_rarity != "", "Rarity cannot be empty")
	
	item_id = p_item_id
	item_name = p_item_name
	rarity = p_rarity