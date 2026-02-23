extends RefCounted
class_name DiceRollResultPayload

## Dice roll result event payload
## Used when dice roll result is available

var stream: GameGlobals.DiceStream
var result_value: int
var is_crit: bool

func _init(
	p_stream: GameGlobals.DiceStream,
	p_result_value: int,
	p_is_crit: bool
) -> void:
	assert(
		p_stream in GameGlobals.DiceStream.values(),
		"Invalid DiceStream"
	)
	
	assert(
		p_result_value >= 1 and p_result_value <= 20,
		"Roll must be 1-20"
	)
	
	stream = p_stream
	result_value = p_result_value
	is_crit = p_is_crit