extends GutTest

## RunState Authority Tests
## Verify RunState authority model is enforced

var run_state: RunState

func before_each() -> void:
	run_state = RunState.new()
	run_state.initialize_run(12345)

func test_run_state_initialization() -> void:
	assert_eq(run_state.run_seed, 12345)
	assert_eq(run_state.health, 100)
	assert_eq(run_state.max_health, 100)
	assert_eq(run_state.luck, 0.0)
	assert_eq(run_state.level_modifier, 1.0)
	assert_eq(run_state.stored_dice.size(), 0)
	assert_eq(run_state.active_boons.size(), 0)

func test_set_health_authority() -> void:
	run_state.set_health(50)
	assert_eq(run_state.get_health(), 50)

func test_set_health_clamps_to_max() -> void:
	run_state.set_health(150)
	assert_eq(run_state.get_health(), 100)

func test_set_health_clamps_to_zero() -> void:
	run_state.set_health(-10)
	assert_eq(run_state.get_health(), 0)

func test_modify_luck_authority() -> void:
	run_state.modify_luck(1.5)
	assert_eq(run_state.luck, 1.5)
	run_state.modify_luck(-0.5)
	assert_eq(run_state.luck, 1.0)

func test_add_stored_dice_authority() -> void:
	var result = run_state.add_stored_dice(6)
	assert_true(result, "Should add first dice")
	assert_eq(run_state.get_stored_dice_count(), 1)

func test_stored_dice_max_limit() -> void:
	run_state.add_stored_dice(6)
	run_state.add_stored_dice(5)
	run_state.add_stored_dice(4)
	var result = run_state.add_stored_dice(3)
	assert_false(result, "Should reject 4th dice")
	assert_eq(run_state.get_stored_dice_count(), 3)

func test_use_stored_dice_authority() -> void:
	run_state.add_stored_dice(6)
	run_state.add_stored_dice(5)
	var value = run_state.use_stored_dice()
	assert_eq(value, 6, "Should return first dice (FIFO)")
	assert_eq(run_state.get_stored_dice_count(), 1)

func test_use_stored_dice_when_empty() -> void:
	var value = run_state.use_stored_dice()
	assert_eq(value, -1, "Should return -1 when empty")

func test_add_boon_authority() -> void:
	run_state.add_boon("double_damage")
	assert_eq(run_state.active_boons.size(), 1)
	assert_true(run_state.active_boons.has("double_damage"))

func test_add_boon_no_duplicates() -> void:
	run_state.add_boon("double_damage")
	run_state.add_boon("double_damage")
	assert_eq(run_state.active_boons.size(), 1)

func test_remove_boon_authority() -> void:
	run_state.add_boon("double_damage")
	run_state.remove_boon("double_damage")
	assert_eq(run_state.active_boons.size(), 0)

func test_set_level_modifier_authority() -> void:
	run_state.set_level_modifier(1.5)
	assert_eq(run_state.level_modifier, 1.5)
