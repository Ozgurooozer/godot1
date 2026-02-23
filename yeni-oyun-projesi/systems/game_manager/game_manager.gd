extends Node

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