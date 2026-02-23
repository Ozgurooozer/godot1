extends RefCounted
class_name ModifierPayload

## Modifier application event payload
## Used when level or combat modifiers are applied

var modifier_value: float
var mod_type: GameGlobals.ModifierType

func _init(
	p_modifier_value: float,
	p_mod_type: GameGlobals.ModifierType
) -> void:
	assert(!is_nan(p_modifier_value), "Modifier value cannot be NaN")
	assert(
		p_mod_type in GameGlobals.ModifierType.values(),
		"Invalid ModifierType"
	)
	
	modifier_value = p_modifier_value
	mod_type = p_mod_type