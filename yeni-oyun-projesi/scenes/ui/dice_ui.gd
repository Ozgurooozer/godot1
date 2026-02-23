class_name DiceUI
extends CanvasLayer

## v5.0 DiceUI - Visual representation of dice rolls
## Responsibility: Playing animations and displaying results.

@export var result_label: Label
@export var modifier_label: Label

func _ready() -> void:
	EventBus.dice_roll_completed.connect(_on_roll_completed)
	EventBus.ui_dice_animation_requested.connect(_on_animation_requested)

func _on_animation_requested(roll: int, modifier: Resource) -> void:
	print("[DiceUI] Playing roll animation for: ", roll)
	
	# Play roll sound via EventBus
	# EventBus.infra_audio_play_sfx.emit(roll_sound, Vector3.ZERO)
	
	# In a real scenario, we'd wait for animation to finish
	_on_roll_completed(null) 

func _on_roll_completed(result: Resource) -> void:
	if not result:
		return
		
	# Play result impact sound
	# EventBus.infra_audio_play_sfx.emit(result_sound, Vector3.ZERO)
	
	# Visual feedback (Scale/Flash)
	_play_result_vfx()
	if not result:
		return
		
	print("[DiceUI] Displaying result: ", result.raw_roll)
	if result_label:
		result_label.text = "Roll: " + str(result.raw_roll)
	if modifier_label and result.modifier:
		modifier_label.text = result.modifier.name + ": " + result.modifier.description

func _play_result_vfx() -> void:
	# Godot 4 Tween for UI feedback
	var tween = create_tween()
	tween.tween_property(result_label, "scale", Vector2(1.5, 1.5), 0.1)
	tween.tween_property(result_label, "scale", Vector2(1.0, 1.0), 0.2)
	# Add a color flash
	result_label.modulate = Color.GOLD
	tween.parallel().tween_property(result_label, "modulate", Color.WHITE, 0.5)
