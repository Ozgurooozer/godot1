class_name GameManager
extends Node

var run_domain: RunDomain

func _init():
	run_domain = RunDomain.new()

# ============================================================
# GameManager
# Ultimate authority over run lifecycle.
# No RNG ownership.
# No RunState access.
# No gameplay logic.
# ============================================================

func start_new_run() -> void:
	var seed: int = _generate_root_seed()
	assert(seed != 0, "Generated root seed must not be zero.")
	
	var payload: RunStartPayload = RunStartPayload.new(seed)
	EventBus.run_started.emit(payload)

func end_run() -> void:
	EventBus.run_ended.emit()

# ============================================================
# Private
# ============================================================

func _generate_root_seed() -> int:
	var unix_time: int = Time.get_unix_time_from_system()
	var ticks_usec: int = Time.get_ticks_usec()
	
	# Combine using bitwise mixing to reduce collision probability
	var mixed: int = unix_time ^ (ticks_usec << 13)
	
	# Ensure non-zero (avoid invalid seed)
	if mixed == 0:
		mixed = 1
	
	return mixed

func calculate_final_damage(base_damage: float) -> float:
    var run_state := run_domain.run_state
    
    var level_mod_pct := 0.0
    var combat_mod_pct := 0.0
    var boon_mod_pct := run_state.get_total_modifier(StatType.DAMAGE_PERCENT)
    
    if run_state.active_level_modifier:
        level_mod_pct = run_state.active_level_modifier.damage_modifier_pct
        
    if run_state.active_combat_modifier:
        combat_mod_pct = run_state.active_combat_modifier.damage_modifier_pct
        
    # Tüm yüzdeler TOPLANIR (Additive)
    var total_pct_modifier := level_mod_pct + combat_mod_pct + boon_mod_pct
    
    # Base ile çarpılır. max() ile hasarın negatife veya 0'a düşmesi (bug) engellenir.
    var final_damage := base_damage * maxf(0.1, 1.0 + total_pct_modifier)
    
    return final_damage
