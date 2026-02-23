class_name MovementComponent
extends Node

## v5.0 MovementComponent - WASD + Dash logic
## Responsibility: Handling CharacterBody3D movement.

@export var parent_body: CharacterBody3D
@export var move_speed: float = 5.0
@export var acceleration: float = 20.0
@export var friction: float = 15.0

var _input_dir: Vector2 = Vector2.ZERO
var _velocity: Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	if not parent_body:
		return
		
	_handle_input()
	_apply_movement(delta)

func _handle_input() -> void:
	_input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")

func _apply_movement(delta: float) -> void:
	var direction = (Vector3(_input_dir.x, 0, _input_dir.y)).normalized()
	
	if direction:
		_velocity.x = lerp(_velocity.x, direction.x * move_speed, acceleration * delta)
		_velocity.z = lerp(_velocity.z, direction.z * move_speed, acceleration * delta)
	else:
		_velocity.x = lerp(_velocity.x, 0.0, friction * delta)
		_velocity.z = lerp(_velocity.z, 0.0, friction * delta)
		
	parent_body.velocity = _velocity
	parent_body.move_and_slide()
