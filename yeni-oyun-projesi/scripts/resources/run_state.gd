class_name RunState
extends RefCounted

## v5.0 RunState - Authoritative State for the Run
## Constraint: Single source of truth for all gameplay data.

# RUN META
var seed: int = 0
var current_floor: int = 1
var rooms_cleared: int = 0
var total_enemies_killed: int = 0

# PLAYER STATS (Authoritative)
var player_max_health: float = 100.0
var player_current_health: float = 100.0
var player_damage_base: float = 10.0
var player_speed_base: float = 5.0
var player_luck: float = 0.0
var player_gold: int = 0

# ACTIVE MODIFIERS
var active_level_modifier: RunModifier
var active_combat_modifier: RunModifier

# STORED DICE
var stored_dice_list: Array = [] # Array of StoredDice resources

# PROGRESSION
var active_boons: Array[StringName] = []
var weapon_id: StringName = &""
var collected_items: Array[StringName] = []

# ROOM
var current_room: Resource # Placeholder for RoomData

func modify_health(delta: float) -> void:
	player_current_health = clampf(player_current_health + delta, 0.0, player_max_health)
	EventBus.combat_health_changed.emit(&"player", player_current_health)
	if player_current_health <= 0.0:
		EventBus.combat_entity_died.emit(&"player")

func clear_combat_modifier() -> void:
	active_combat_modifier = null
	EventBus.run_modifier_applied.emit(null)

func to_dict() -> Dictionary:
	return {
		"seed": seed,
		"current_floor": current_floor,
		"rooms_cleared": rooms_cleared,
		"player_current_health": player_current_health,
		"player_max_health": player_max_health,
		"player_luck": player_luck,
		"player_gold": player_gold,
		"active_boons": active_boons,
		"weapon_id": str(weapon_id),
		"stored_dice_count": stored_dice_list.size()
	}

static func from_dict(d: Dictionary) -> RunState:
	var rs := RunState.new()
	rs.seed = d.get("seed", 0)
	rs.current_floor = d.get("current_floor", 1)
	rs.rooms_cleared = d.get("rooms_cleared", 0)
	rs.player_current_health = d.get("player_current_health", 100.0)
	rs.player_max_health = d.get("player_max_health", 100.0)
	rs.player_luck = d.get("player_luck", 0.0)
	rs.player_gold = d.get("player_gold", 0)
	rs.weapon_id = StringName(d.get("weapon_id", ""))
	return rs
