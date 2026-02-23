extends RefCounted
class_name DiceRollRequestPayload

## Dice roll request event payload
## Used when dice roll is requested

var stream: GameGlobals.DiceStream

func _init(p_stream: GameGlobals.DiceStream) -> void:
	assert(
		p_stream in GameGlobals.DiceStream.values(),
		"Invalid DiceStream"
	)
	
	stream = p_stream