class_name EntityRegistry
extends Node

## v5.0 EntityRegistry - Manages Active Entities
## Responsibility: Registration, tracking, retrieval.
## Constraint: No authoritative state, only node references.

var _entities: Dictionary = {} # StringName -> Node3D

func _ready() -> void:
	EventBus.entity_registered.connect(_on_entity_registered)
	EventBus.entity_unregistered.connect(_on_entity_unregistered)

func _on_entity_registered(entity_id: StringName, node: Node3D) -> void:
	_entities[entity_id] = node
	print("[EntityRegistry] Registered: ", entity_id)

func _on_entity_unregistered(entity_id: StringName) -> void:
	_entities.erase(entity_id)
	print("[EntityRegistry] Unregistered: ", entity_id)

func get_entity(entity_id: StringName) -> Node3D:
	return _entities.get(entity_id)

func get_player() -> Node3D:
	return get_entity(&"player")
