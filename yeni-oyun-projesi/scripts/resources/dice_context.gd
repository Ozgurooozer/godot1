class_name DiceContext
extends Resource

## v5.0 DiceContext - Defines why a roll is being made

enum ContextType {
	LEVEL_START,
	COMBAT_START,
	STORED_OVERRIDE,
	LOOT_ROLL,
	CHEST_OPEN
}

@export var context_type: ContextType
@export var entity_id: StringName # Who is it for?
@export var luck_value: float = 0.0
