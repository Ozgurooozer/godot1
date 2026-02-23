class_name AIState
extends Resource

## v5.0 AIState - Base interface for AI states
## Responsibility: Defining enter, exit, and update logic.

func enter(_actor: Node) -> void:
	pass

func exit(_actor: Node) -> void:
	pass

func update(_actor: Node, _delta: float) -> StringName:
	return &"" # Returns the name of the next state or empty
