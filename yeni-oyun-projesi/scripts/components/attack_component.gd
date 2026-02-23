class_name AttackComponent
extends Node

## v5.0 AttackComponent - Handles weapon attacks
## Responsibility: Triggering hitbox activation.

@export var parent_body: CharacterBody3D
@export var hitbox: HitboxComponent
@export var attack_cooldown: float = 0.5

var _can_attack: bool = true

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack") and _can_attack:
		_perform_attack()

func _perform_attack() -> void:
	_can_attack = false
	print("[AttackComponent] Attacking...")
	
	if hitbox:
		hitbox.monitoring = true
		await get_tree().create_timer(0.1).timeout
		hitbox.monitoring = false
	
	await get_tree().create_timer(attack_cooldown).timeout
	_can_attack = true
