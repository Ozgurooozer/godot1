class_name RunDomain
extends Node

## v5.0 RunDomain - Manages RunState Lifecycle
## Responsibility: Authoritative State Management, Event Handling.

var run_state: RunState

func _ready() -> void:
	EventBus.run_started.connect(_on_run_started)
	EventBus.combat_damage_requested.connect(_on_damage_requested)
	EventBus.dice_modifier_generated.connect(_on_modifier_generated)

func _on_run_started(p_seed: int) -> void:
	run_state = RunState.new()
	run_state.seed = p_seed
	print("[RunDomain] Run started with seed: ", p_seed)

func _on_damage_requested(entity_id: StringName, amount: float) -> void:
	if entity_id == &"player":
		run_state.modify_health(-amount)
	else:
		# Handle enemy damage mirror logic if needed
		pass

func _on_modifier_generated(modifier: RunModifier) -> void:
	# Context-based logic should decide if it's level or combat
	# For simplicity, we assume the latest generated modifier is applied
	run_state.active_combat_modifier = modifier
	EventBus.run_modifier_applied.emit(modifier)
