class_name VFXManager
extends Node

## v5.0 VFXManager - Global Particle & Visual Effects Controller
## Responsibility: Instantiating and pooling visual effects.

@export var hit_effect_scene: PackedScene
@export var slash_effect_scene: PackedScene
@export var death_effect_scene: PackedScene

func _ready() -> void:
	# VFX tetiklemeleri için sinyalleri burada bağlayabiliriz
	pass

func spawn_vfx(vfx_scene: PackedScene, position: Vector3, rotation: Vector3 = Vector3.ZERO) -> void:
	if not vfx_scene:
		return
		
	var vfx = vfx_scene.instantiate()
	get_tree().root.add_child(vfx)
	vfx.global_position = position
	vfx.global_rotation = rotation
	
	if vfx is GPUParticles3D:
		vfx.emitting = true
		# Auto-free after emission finished (if one-shot)
		if vfx.one_shot:
			await get_tree().create_timer(vfx.lifetime + 0.5).timeout
			vfx.queue_free()

func spawn_hit_vfx(position: Vector3) -> void:
	spawn_vfx(hit_effect_scene, position)

func spawn_slash_vfx(position: Vector3, direction: Vector3) -> void:
	# Direction to rotation logic
	var rot = Vector3(0, atan2(direction.x, direction.z), 0)
	spawn_vfx(slash_effect_scene, position, rot)
