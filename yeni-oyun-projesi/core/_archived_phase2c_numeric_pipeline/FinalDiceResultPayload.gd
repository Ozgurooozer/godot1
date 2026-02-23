class_name FinalDiceResultPayload
extends RefCounted

## Final dice result payload (after modifiers applied)
## Used when dice roll is finalized with modifiers

var stream: GameGlobals.DiceStream
var raw_value: int
var modified_value: int
var is_crit: bool

func _init(
	p_stream: GameGlobals.DiceStream,
	p_raw_value: int,
	p_modified_value: int,
	p_is_crit: bool
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
		p_modified_value >= 0,
		"Modified value cannot be negative"
	)
	
	assert(
		typeof(p_is_crit) == TYPE_BOOL,
		"is_crit must be boolean"
	)
	
	stream = p_stream
	raw_value = p_raw_value
	modified_value = p_modified_value
	is_crit = p_is_crit
