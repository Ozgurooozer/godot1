extends Node

## Global Event Bus - Single Autoload
## All cross-domain communication MUST use this EventBus
## Signals follow DTO rule: 0 parameters OR 1 DTO parameter only

# ============================================================
# Run Lifecycle
# ============================================================

signal run_started(payload: RunStartPayload)
signal run_ended()
signal run_health_changed(payload: HealthChangedPayload)
signal run_modifier_applied(payload: ModifierPayload)

# ============================================================
# Combat Lifecycle
# ============================================================

signal combat_started(payload: CombatStartPayload)
signal combat_ended()
signal combat_damage_requested(payload: DamageRequestPayload)
signal combat_damage_applied(payload: DamagePayload)

# ============================================================
# Dice System
# ============================================================

signal dice_roll_requested(payload: DiceRollRequestPayload)
signal dice_roll_result(payload: DiceRollResultPayload)

# ============================================================
# Loot System
# ============================================================

signal loot_roll_requested(payload: LootRollRequestPayload)
signal loot_roll_result(payload: LootRollResultPayload)

# ============================================================
# Stored Dice System
# ============================================================

signal stored_dice_added(payload: StoredDicePayload)
signal stored_dice_used(payload: StoredDicePayload)
