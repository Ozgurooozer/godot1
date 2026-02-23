class_name CameraRig
extends Node3D

## v5.0 CameraRig - Isometric Camera with Screen Shake
## Responsibility: Smooth following and feedback.

@export var target: Node3D
@export var smooth_speed: float = 5.0
@export var offset: Vector3 = Vector3(10, 10, 10)

@onready var camera: Camera3D = $Camera3D

var _shake_intensity: float = 0.0
var _shake_decay: float = 5.0

func _ready() -> void:
	EventBus.combat_hit_landed.connect(_on_hit_landed)

func _process(delta: float) -> void:
	if target:
		var target_pos = target.global_position + offset
		global_position = global_position.lerp(target_pos, smooth_speed * delta)
		
	_apply_shake(delta)

func _apply_shake(delta: float) -> void:
	if _shake_intensity > 0:
		var offset_shake = Vector3(
			randf_range(-_shake_intensity, _shake_intensity),
			randf_range(-_shake_intensity, _shake_intensity),
			randf_range(-_shake_intensity, _shake_intensity)
		)
		camera.h_offset = offset_shake.x
		camera.v_offset = offset_shake.y
		_shake_intensity = lerp(_shake_intensity, 0.0, _shake_decay * delta)
	else:
		camera.h_offset = 0
		camera.v_offset = 0

func _on_hit_landed(_attacker: StringName, _target: StringName) -> void:
	shake(0.2)

func shake(intensity: float) -> void:
	_shake_intensity = intensity
