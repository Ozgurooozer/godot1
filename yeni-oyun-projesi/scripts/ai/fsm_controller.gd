class_name FSMController
extends Node

## v5.0 FSMController - Manages AI state machine
## Responsibility: State transitions and update loop.
## Constraint: THINK_INTERVAL = 0.1s for decisions.

@export var actor: Node
@export var initial_state: StringName = &"idle"
@export var states: Dictionary = {} # StringName -> AIState

var _current_state_name: StringName = &""
var _current_state: AIState = null
var _think_timer: float = 0.0
const THINK_INTERVAL: float = 0.1

func _ready() -> void:
	if not actor:
		actor = get_parent()
	
	_change_state(initial_state)

func _physics_process(delta: float) -> void:
	if not _current_state:
		return
		
	_think_timer += delta
	if _think_timer >= THINK_INTERVAL:
		_think_timer = 0.0
		var next_state = _current_state.update(actor, delta)
		if next_state != &"":
			_change_state(next_state)

func _change_state(new_state_name: StringName) -> void:
	if not states.has(new_state_name):
		push_error("[FSMController] State not found: ", new_state_name)
		return
		
	if _current_state:
		_current_state.exit(actor)
		
	_current_state_name = new_state_name
	_current_state = states[new_state_name]
	_current_state.enter(actor)
	print("[FSMController] Changed state to: ", _current_state_name)
