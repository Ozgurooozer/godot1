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
	_on_roll_completed(null) 

func _on_roll_completed(result: Resource) -> void:
	if not result:
		return
		
	print("[DiceUI] Displaying result: ", result.raw_roll)
	if result_label:
		result_label.text = "Roll: " + str(result.raw_roll)
	if modifier_label and result.modifier:
		modifier_label.text = result.modifier.name + ": " + result.modifier.description
