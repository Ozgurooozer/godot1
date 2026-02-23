class_name DiceDomain
extends Node

# ============================================================
# DiceDomain - EXCLUSIVE RNG OWNER
# The ONLY class in the entire project allowed to use RandomNumberGenerator.
# All RNG requests must go through EventBus.
# No gameplay state storage - only RNG instances.
# ============================================================

# Private RNG instances - ephemeral state only
var _level_rng: RandomNumberGenerator
var _combat_rng: RandomNumberGenerator
var _loot_rng: RandomNumberGenerator
var _stored_dice_rng: RandomNumberGenerator

func _ready() -> void:
	# Connect to EventBus signals
	EventBus.run_started.connect(_on_run_started)
	EventBus.dice_roll_requested.connect(_on_dice_roll_requested)

func _on_run_started(payload: RunStartPayload) -> void:
	assert(payload != null, "RunStartPayload cannot be null.")
	assert(payload.root_seed != 0, "Root seed cannot be zero.")
	
	# Initialize RNG instances
	_level_rng = RandomNumberGenerator.new()
	_combat_rng = RandomNumberGenerator.new()
	_loot_rng = RandomNumberGenerator.new()
	_stored_dice_rng = RandomNumberGenerator.new()
	
	# Hash-based seed derivation for strong isolation
	# Using deterministic hash to prevent stream overlap
	_level_rng.seed = hash(str(payload.root_seed) + "level")
	_combat_rng.seed = hash(str(payload.root_seed) + "combat")
	_loot_rng.seed = hash(str(payload.root_seed) + "loot")
	_stored_dice_rng.seed = hash(str(payload.root_seed) + "stored_dice")

func _on_dice_roll_requested(payload: DiceRollRequestPayload) -> void:
	assert(payload != null, "DiceRollRequestPayload cannot be null.")
	assert(_level_rng != null, "RNGs not initialized! Run must be started first.")
	
	var roll: int = 0
	var is_crit: bool = false
	
	# Exhaustive match on DiceStream enum
	match payload.stream:
		GameGlobals.DiceStream.LEVEL:
			roll = _level_rng.randi_range(1, 20)
		GameGlobals.DiceStream.COMBAT:
			roll = _combat_rng.randi_range(1, 20)
		GameGlobals.DiceStream.LOOT:
			roll = _loot_rng.randi_range(1, 20)
		GameGlobals.DiceStream.STORED_DICE:
			roll = _stored_dice_rng.randi_range(1, 20)
		_:
			push_error("Unknown DiceStream!")
			return
	
	# Determine critical hit
	is_crit = (roll == 20)
	
	# Create result payload and emit
	var result_payload: DiceRollResultPayload = DiceRollResultPayload.new(
		payload.stream,
		roll,
		is_crit
	)
	
	EventBus.dice_roll_result.emit(result_payload)