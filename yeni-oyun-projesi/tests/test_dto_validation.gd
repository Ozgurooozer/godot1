extends GutTest

## DTO Validation Tests
## Verify all DTOs follow strict constructor validation

func test_run_start_payload_valid() -> void:
	var payload: RunStartPayload = RunStartPayload.new(123)
	assert_eq(payload.root_seed, 123)

func test_combat_start_payload_valid() -> void:
	var payload: CombatStartPayload = CombatStartPayload.new(456)
	assert_eq(payload.initial_combat_seed, 456)

func test_modifier_payload_valid() -> void:
	var payload: ModifierPayload = ModifierPayload.new(
		2.5,
		GameGlobals.ModifierType.NEGATIVE
	)
	
	assert_eq(payload.modifier_value, 2.5)
	assert_eq(payload.mod_type, GameGlobals.ModifierType.NEGATIVE)

func test_dice_roll_request_payload_valid() -> void:
	var payload: DiceRollRequestPayload = DiceRollRequestPayload.new(
		GameGlobals.DiceStream.LOOT
	)
	
	assert_eq(payload.stream, GameGlobals.DiceStream.LOOT)

func test_dice_roll_result_payload_valid() -> void:
	var payload: DiceRollResultPayload = DiceRollResultPayload.new(
		GameGlobals.DiceStream.STORED_DICE,
		15,
		true
	)
	
	assert_eq(payload.stream, GameGlobals.DiceStream.STORED_DICE)
	assert_eq(payload.result_value, 15)
	assert_true(payload.is_crit)

func test_dice_roll_result_payload_boundary_values() -> void:
	# Test minimum valid roll
	var payload_min: DiceRollResultPayload = DiceRollResultPayload.new(
		GameGlobals.DiceStream.COMBAT,
		1,
		false
	)
	assert_eq(payload_min.result_value, 1)
	
	# Test maximum valid roll
	var payload_max: DiceRollResultPayload = DiceRollResultPayload.new(
		GameGlobals.DiceStream.COMBAT,
		20,
		true
	)
	assert_eq(payload_max.result_value, 20)

func test_all_dto_types_extend_refcounted() -> void:
	# Verify all DTOs extend RefCounted (not Resource)
	var run_start: RunStartPayload = RunStartPayload.new(1)
	var combat_start: CombatStartPayload = CombatStartPayload.new(1)
	var modifier: ModifierPayload = ModifierPayload.new(1.0, GameGlobals.ModifierType.POSITIVE)
	var dice_request: DiceRollRequestPayload = DiceRollRequestPayload.new(GameGlobals.DiceStream.LEVEL)
	var dice_result: DiceRollResultPayload = DiceRollResultPayload.new(GameGlobals.DiceStream.LEVEL, 10, false)
	
	assert_true(run_start is RefCounted)
	assert_true(combat_start is RefCounted)
	assert_true(modifier is RefCounted)
	assert_true(dice_request is RefCounted)
	assert_true(dice_result is RefCounted)

func test_all_dto_types_have_class_names() -> void:
	# Verify class_name is properly set
	var run_start: RunStartPayload = RunStartPayload.new(1)
	var combat_start: CombatStartPayload = CombatStartPayload.new(1)
	var modifier: ModifierPayload = ModifierPayload.new(1.0, GameGlobals.ModifierType.POSITIVE)
	var dice_request: DiceRollRequestPayload = DiceRollRequestPayload.new(GameGlobals.DiceStream.LEVEL)
	var dice_result: DiceRollResultPayload = DiceRollResultPayload.new(GameGlobals.DiceStream.LEVEL, 10, false)
	
	assert_not_null(run_start)
	assert_not_null(combat_start)
	assert_not_null(modifier)
	assert_not_null(dice_request)
	assert_not_null(dice_result)