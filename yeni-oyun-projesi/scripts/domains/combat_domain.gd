class_name CombatDomain
extends Node

## v5.0 CombatDomain - Damage & Hit Resolution
## Responsibility: calculate_damage(), process_hit(), effect_application.
## Constraint: No authoritative state, reads from RunState, emits events.

func _ready() -> void:
	# Listens for damage requests from entities
	EventBus.combat_damage_requested.connect(_on_damage_requested)

func calculate_damage(base: float, _attacker_id: StringName) -> float:
	# v5.0 Damage Flow: base * (1 + level_mod) * (1 + combat_mod)
	# (Modified to additive if required, but v5.0 doc says multiplicative 1.0 + bonus)
	var run_state: RunState = GameManager.instance.run_domain.run_state
	var lm := run_state.active_level_modifier
	var cm := run_state.active_combat_modifier
	
	var total := base
	if lm:
		total *= (1.0 + lm.damage_bonus)
	if cm:
		total *= (1.0 + cm.damage_bonus)
	
	# v5.0 Protection: Max(0.1, result) to prevent 0 or negative damage
	return maxf(0.1, total)

func _on_damage_requested(entity_id: StringName, amount: float) -> void:
	# Calculate final damage with modifiers
	var final_damage := calculate_damage(amount, &"unknown")
	
	# Log for debug
	print("[CombatDomain] Processing damage for %s: %f -> %f" % [entity_id, amount, final_damage])
	
	# VFX/SFX Triggering
	var entity = GameManager.instance.entity_registry.get_entity(entity_id)
	if entity:
		var vfx_pos = entity.global_position + Vector3.UP * 1.0 # Hit center
		GameManager.instance.vfx_manager.spawn_hit_vfx(vfx_pos)
		# Audio trigger via EventBus (assuming a default hit sound for now)
		# EventBus.infra_audio_play_sfx.emit(hit_sound_resource, vfx_pos)
	
	# Damage is then applied via RunDomain which updates RunState
	# (In this architecture, RunDomain is the one that actually writes to RunState)
	# But for simplicity, we let RunDomain handle the health modification
	# which we already implemented in Phase 2.
