class_name DiceDomain
extends Node

# ============================================================
# DiceDomain - EXCLUSIVE RNG OWNER + CATEGORY GENERATOR
# The ONLY class in the entire project allowed to use RandomNumberGenerator.
# Responsibilities:
#   1. Roll d20 (deterministic per stream)
#   2. Convert raw_value → RollCategory
#   3. Generate RunModifier resource based on category
#   4. Emit dice_roll_result with category + modifier
# 
# DiceDomain does NOT:
#   - Calculate final numeric results
#   - Apply modifiers to gameplay
#   - Store state
#   - Perform combat calculations
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
	_level_rng.seed = hash(str(payload.root_seed) + "level")
	_combat_rng.seed = hash(str(payload.root_seed) + "combat")
	_loot_rng.seed = hash(str(payload.root_seed) + "loot")
	_stored_dice_rng.seed = hash(str(payload.root_seed) + "stored_dice")

func _on_dice_roll_requested(payload: DiceRollRequestPayload) -> void:
	assert(payload != null, "DiceRollRequestPayload cannot be null.")
	assert(_level_rng != null, "RNGs not initialized! Run must be started first.")
	
	var roll: int = 0
	
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
	
	# Convert raw roll to category
	var category: GameGlobals.RollCategory = _roll_to_category(roll)
	
	# Generate RunModifier resource based on category
	var modifier: RunModifier = _generate_modifier(category)
	
	# Create result payload and emit
	var result_payload: DiceRollResultPayload = DiceRollResultPayload.new(
		payload.stream,
		roll,
		category,
		modifier
	)
	
	EventBus.dice_roll_result.emit(result_payload)

# ============================================================
# Private: Category Mapping
# ============================================================

func _roll_to_category(roll: int) -> GameGlobals.RollCategory:
	# PLACEHOLDER: Will be replaced with your mapping strategy
	# Current simple mapping:
	if roll == 1:
		return GameGlobals.RollCategory.DISASTER
	elif roll >= 2 and roll <= 7:
		return GameGlobals.RollCategory.BAD
	elif roll >= 8 and roll <= 13:
		return GameGlobals.RollCategory.NEUTRAL
	elif roll >= 14 and roll <= 19:
		return GameGlobals.RollCategory.GOOD
	elif roll == 20:
		return GameGlobals.RollCategory.JACKPOT
	else:
		push_error("Invalid roll value: %d" % roll)
		return GameGlobals.RollCategory.NEUTRAL

# ============================================================
# Private: Modifier Generation
# ============================================================

func _generate_modifier(category: GameGlobals.RollCategory) -> RunModifier:
	# PLACEHOLDER: Will be replaced with your generation strategy
	# Current simple mapping:
	match category:
		GameGlobals.RollCategory.DISASTER:
			return RunModifier.create(0.5, 1.5, 0.5, "Disaster: Weak damage, tough enemies, poor loot")
		GameGlobals.RollCategory.BAD:
			return RunModifier.create(0.8, 1.2, 0.8, "Bad: Reduced effectiveness")
		GameGlobals.RollCategory.NEUTRAL:
			return RunModifier.create(1.0, 1.0, 1.0, "Neutral: Standard run")
		GameGlobals.RollCategory.GOOD:
			return RunModifier.create(1.2, 0.8, 1.2, "Good: Enhanced effectiveness")
		GameGlobals.RollCategory.JACKPOT:
			return RunModifier.create(1.5, 0.5, 1.5, "Jackpot: Strong damage, weak enemies, great loot!")
		_:
			push_error("Unknown RollCategory!")
			return RunModifier.create(1.0, 1.0, 1.0, "Error: Default modifier")
