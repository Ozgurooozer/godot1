extends GutTest

## Phase 2 Integration Tests
## Test GameManager → EventBus → DiceDomain flow

var game_manager: GameManager
var dice_domain: DiceDomain

func before_each() -> void:
	# Create instances
	game_manager = GameManager.new()
	dice_domain = DiceDomain.new()
	
	# Add to scene tree (required for _ready)
	add_child(game_manager)
	add_child(dice_domain)

func after_each() -> void:
	if game_manager:
		game_manager.queue_free()
	if dice_domain:
		dice_domain.queue_free()

func test_game_manager_generates_seed() -> void:
	# Test seed generation
	var seed1: int = game_manager._generate_root_seed()
	var seed2: int = game_manager._generate_root_seed()
	
	assert_ne(seed1, 0, "Seed should not be zero")
	assert_ne(seed2, 0, "Seed should not be zero")
	# Seeds should be different (time-based)
	assert_ne(seed1, seed2, "Seeds should be unique")

func test_run_start_payload_creation() -> void:
	# Test payload creation
	var payload: RunStartPayload = RunStartPayload.new(12345)
	assert_eq(payload.root_seed, 12345, "Payload should store seed")

func test_dice_roll_request_payload_enum() -> void:
	# Test enum usage
	var payload: DiceRollRequestPayload = DiceRollRequestPayload.new(GameGlobals.DiceStream.COMBAT)
	assert_eq(payload.stream, GameGlobals.DiceStream.COMBAT, "Should store enum value")

func test_dice_roll_result_payload_creation() -> void:
	# Test result payload
	var payload: DiceRollResultPayload = DiceRollResultPayload.new(
		GameGlobals.DiceStream.LEVEL,
		15,
		false
	)
	assert_eq(payload.stream, GameGlobals.DiceStream.LEVEL)
	assert_eq(payload.result_value, 15)
	assert_eq(payload.is_crit, false)

func test_eventbus_signals_exist() -> void:
	# Test signal existence
	assert_has_signal(EventBus, "run_started")
	assert_has_signal(EventBus, "dice_roll_requested")
	assert_has_signal(EventBus, "dice_roll_result")

func test_integration_flow() -> void:
	# Test full integration flow
	watch_signals(EventBus)
	
	# Start run
	game_manager.start_new_run()
	
	# Verify run_started was emitted
	assert_signal_emitted(EventBus, "run_started")
	
	# Wait a frame for DiceDomain to initialize
	await get_tree().process_frame
	
	# Request dice roll
	var request: DiceRollRequestPayload = DiceRollRequestPayload.new(GameGlobals.DiceStream.COMBAT)
	EventBus.dice_roll_requested.emit(request)
	
	# Wait a frame for processing
	await get_tree().process_frame
	
	# Verify dice_roll_result was emitted
	assert_signal_emitted(EventBus, "dice_roll_result")