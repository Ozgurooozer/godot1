class_name HitboxComponent
extends Area3D

## v5.0 HitboxComponent - Deals damage on contact
## Responsibility: Triggering damage calculation.

@export var damage: float = 10.0
@export var attacker_id: StringName = &"unknown"

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area3D) -> void:
	if area is HurtboxComponent:
		var hurtbox: HurtboxComponent = area
		hurtbox.receive_hit(damage, attacker_id)
		print("[HitboxComponent] Hit landed on: ", hurtbox.owner_id)
