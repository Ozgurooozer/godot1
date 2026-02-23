class_name PerceptionComponent
extends Node3D

## v5.0 PerceptionComponent - Enemy detection logic
## Responsibility: Tracking targets within FOV and range.

@export var detection_range: float = 10.0
@export var field_of_view: float = 90.0
@export var raycast: RayCast3D

var _targets: Array[Node3D] = []

func _ready() -> void:
	var area = Area3D.new()
	var collision = CollisionShape3D.new()
	var sphere = SphereShape3D.new()
	sphere.radius = detection_range
	collision.shape = sphere
	area.add_child(collision)
	add_child(area)
	
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		_targets.append(body)

func _on_body_exited(body: Node3D) -> void:
	if body in _targets:
		_targets.erase(body)

func get_nearest_target() -> Node3D:
	if _targets.is_empty():
		return null
	return _targets[0]
