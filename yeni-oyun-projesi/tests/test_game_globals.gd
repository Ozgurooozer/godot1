extends GutTest

## Game Globals Constants Tests
## Verify constants are defined and immutable

func test_max_stored_dice_constant() -> void:
	assert_eq(GameGlobals.MAX_STORED_DICE, 3)

func test_base_health_constant() -> void:
	assert_eq(GameGlobals.BASE_HEALTH, 100)

func test_dice_sides_constant() -> void:
	assert_eq(GameGlobals.DICE_SIDES, 6)

func test_max_enemies_constant() -> void:
	assert_eq(GameGlobals.MAX_ENEMIES, 200)

func test_version_constant() -> void:
	assert_eq(GameGlobals.VERSION, "0.1.0")

func test_phase_constant() -> void:
	assert_eq(GameGlobals.PHASE, "Phase 1 - Core Infrastructure")
