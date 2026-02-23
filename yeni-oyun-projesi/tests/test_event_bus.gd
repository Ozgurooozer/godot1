extends GutTest

## EventBus Contract Tests
## Verify EventBus follows constitution rules and payload contracts

func test_run_started_emits_with_payload() -> void:
	var received_payload: RunStartPayload = null
	
	EventBus.run_started.connect(
		func(payload: RunStartPayload) -> void:
			received_payload = payload
	)
	
	var payload: RunStartPayload = RunStartPayload.new(12345)
	EventBus.run_started.emit(payload)
	
	assert_not_null(received_payload)
	assert_true(received_payload is RunStartPayload)
	assert_eq(received_payload.root_seed, 12345)

func test_run_modifier_applied_emits_with_payload() -> void:
	var received_payload: ModifierPayload = null
	
	EventBus.run_modifier_applied.connect(
		func(payload: ModifierPayload) -> void:
			received_payload = payload
	)
	
	var payload: ModifierPayload = ModifierPayload.new(
		1.5,
		GameGlobals.ModifierType.POSITIVE
	)
	
	EventBus.run_modifier_applied.emit(payload)
	
	assert_not_null(received_payload)
	assert_eq(received_payload.modifier_value, 1.5)
	assert_eq(received_payload.mod_type, GameGlobals.ModifierType.POSITIVE)

func test_combat_started_emits_with_payload() -> void:
	var received_payload: CombatStartPayload = null
	
	EventBus.combat_started.connect(
		func(payload: CombatStartPayload) -> void:
			received_payload = payload
	)
	
	var payload: CombatStartPayload = CombatStartPayload.new(999)
	EventBus.combat_started.emit(payload)
	
	assert_not_null(received_payload)
	assert_eq(received_payload.initial_combat_seed, 999)

func test_dice_roll_requested_emits_with_payload() -> void:
	var received_payload: DiceRollRequestPayload = null
	
	EventBus.dice_roll_requested.connect(
		func(payload: DiceRollRequestPayload) -> void:
			received_payload = payload
	)
	
	var payload: DiceRollRequestPayload = DiceRollRequestPayload.new(
		GameGlobals.DiceStream.COMBAT
	)
	
	EventBus.dice_roll_requested.emit(payload)
	
	assert_not_null(received_payload)
	assert_eq(received_payload.stream, GameGlobals.DiceStream.COMBAT)

func test_dice_roll_result_emits_with_payload() -> void:
	var received_payload: DiceRollResultPayload = null
	
	EventBus.dice_roll_result.connect(
		func(payload: DiceRollResultPayload) -> void:
			received_payload = payload
	)
	
	var payload: DiceRollResultPayload = DiceRollResultPayload.new(
		GameGlobals.DiceStream.LEVEL,
		10,
		false
	)
	
	EventBus.dice_roll_result.emit(payload)
	
	assert_not_null(received_payload)
	assert_eq(received_payload.result_value, 10)
	assert_eq(received_payload.stream, GameGlobals.DiceStream.LEVEL)

func test_event_bus_has_all_required_signals() -> void:
	# Verify all required signals exist
	assert_has_signal(EventBus, "run_started")
	assert_has_signal(EventBus, "run_ended")
	assert_has_signal(EventBus, "run_modifier_applied")
	assert_has_signal(EventBus, "combat_started")
	assert_has_signal(EventBus, "combat_ended")
	assert_has_signal(EventBus, "dice_roll_requested")
	assert_has_signal(EventBus, "dice_roll_result")