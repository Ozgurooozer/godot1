class_name GameGlobals
extends RefCounted

## Game Global Constants and Enumerations
## Constants only - no runtime mutation allowed
## NOT an autoload - accessed via class_name

# Version
const VERSION: String = "0.1.0"
const PHASE: String = "Phase 2C - Dice Category System"

# Stored Dice
const MAX_STORED_DICE: int = 3

# Health
const BASE_HEALTH: int = 100

# Dice
const DICE_SIDES: int = 6

# Performance
const MAX_ENEMIES: int = 200

# ============================================================
# Dice Stream Enumeration
# ============================================================

enum DiceStream {
	LEVEL,
	COMBAT,
	LOOT,
	STORED_DICE
}

# ============================================================
# Roll Category Enumeration
# ============================================================

enum RollCategory {
	DISASTER,
	BAD,
	NEUTRAL,
	GOOD,
	JACKPOT
}

# ============================================================
# Modifier Type Enumeration
# ============================================================

enum ModifierType {
	POSITIVE,
	NEGATIVE
}

# ============================================================
# Stat Type Enumeration
# ============================================================

enum StatType {
	DAMAGE_PERCENT,
	HEALTH_PERCENT,
	LUCK_PERCENT
}
