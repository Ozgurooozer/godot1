class_name HurtboxComponent
extends Area3D

## v5.0 HurtboxComponent - Receives damage on contact
## Responsibility: Relaying damage request to HealthComponent.

@export var owner_id: StringName = &"unknown"
@export var health_component: HealthComponent

func receive_hit(damage: float, _attacker_id: StringName) -> void:
	if health_component:
		health_component.request_damage(damage)
		print("[HurtboxComponent] Hit received for: ", owner_id)
	else:
		push_error("[HurtboxComponent] No HealthComponent found for: ", owner_id)
