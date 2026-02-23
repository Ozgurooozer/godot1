class_name HealthComponent
extends Node

## v5.0 HealthComponent - Mirror of RunState
## Responsibility: Displaying health, requesting damage.
## Constraint: NOT authoritative.

signal health_display_updated(new_val: float)

@export var owner_id: StringName = &"unknown"
var _cached_health: float = 100.0

func _ready() -> void:
	EventBus.combat_health_changed.connect(_on_health_changed)

func _on_health_changed(entity_id: StringName, new_val: float) -> void:
	if entity_id != owner_id:
		return
	
	_cached_health = new_val
	health_display_updated.emit(_cached_health)
	print("[HealthComponent] Entity %s health updated to: %f" % [owner_id, _cached_health])

func request_damage(amount: float) -> void:
	# Sends request to EventBus, which RunDomain/CombatDomain will process
	EventBus.combat_damage_requested.emit(owner_id, amount)
