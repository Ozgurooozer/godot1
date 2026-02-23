class_name DiceRollResultPayload
extends RefCounted

## Dice roll result payload (spec-compliant)
## Contains raw value, category, and generated modifier resource

var stream: GameGlobals.DiceStream
var raw_value: int
var category: GameGlobals.RollCategory
var modifier: RunModifier

func _init(
	p_stream: GameGlobals.DiceStream,
	p_raw_value: int,
	p_category: GameGlobals.RollCategory,
	p_modifier: RunModifier
) -> void:
	assert(
		p_stream in GameGlobals.DiceStream.values(),
		"Invalid DiceStream"
	)
	
	assert(
		p_raw_value >= 1 and p_raw_value <= 20,
		"Raw value must be 1-20"
	)
	
	assert(
		p_category in GameGlobals.RollCategory.values(),
		"Invalid RollCategory"
	)
	
	assert(
		p_modifier != null,
		"RunModifier cannot be null"
	)
	
	stream = p_stream
	raw_value = p_raw_value
	category = p_category
	modifier = p_modifier
