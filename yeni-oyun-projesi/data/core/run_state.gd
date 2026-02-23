class_name RunState
extends Resource

## RunState - The Only Authority for Run Data
## Created fresh per run - NEVER use .tres for runtime mutation
## Only RunState methods may modify state

# State Fields
var health: int = 100
var max_health: int = 100
var luck: float = 0.0
var level_modifier: float = 1.0
var combat_context: Dictionary = {}  # Placeholder for Phase 2
var stored_dice: Array[int] = []
var active_boons: Array[String] = []
var run_seed: int = 0
var active_level_modifier: RunModifier = null
var active_combat_modifier: RunModifier = null

## Initialize a new run with seed
func initialize_run(seed: int) -> void:
	active_level_modifier = null
	active_combat_modifier = null
	run_seed = seed
	health = 100
	max_health = 100
	luck = 0.0
	level_modifier = 1.0
	combat_context = {}
	stored_dice = []
	active_boons = []

## Authority method: Set health
func set_health(value: int) -> void:
	health = clampi(value, 0, max_health)

## Authority method: Modify luck
func modify_luck(delta: float) -> void:
	luck += delta

## Authority method: Add stored dice
## Returns true if added, false if max reached
func add_stored_dice(value: int) -> bool:
	if stored_dice.size() >= 3:  # MAX_STORED_DICE
		return false
	stored_dice.append(value)
	return true

## Authority method: Use stored dice
## Returns dice value, or -1 if none available
func use_stored_dice() -> int:
	if stored_dice.is_empty():
		return -1
	return stored_dice.pop_front()

## Authority method: Set level modifier
func set_level_modifier(value: float) -> void:
	level_modifier = value

## Authority method: Add boon
func add_boon(boon_id: String) -> void:
	if not active_boons.has(boon_id):
		active_boons.append(boon_id)

## Authority method: Remove boon
func remove_boon(boon_id: String) -> void:
	active_boons.erase(boon_id)

## Get current health (read-only)
func get_health() -> int:
	return health

## Get stored dice count (read-only)
func get_stored_dice_count() -> int:
	return stored_dice.size()

func get_total_modifier(stat_type: int) -> float:
	var total_modifier := 0.0
	for boon_id in active_boons:
		# Burada boon\'ların modifier değerleri toplanacak. Şimdilik boş bırakıyorum.
		# Örnek: if boon_id == "BoonOfStrength": total_modifier += 0.1
		pass
	return total_modifier
