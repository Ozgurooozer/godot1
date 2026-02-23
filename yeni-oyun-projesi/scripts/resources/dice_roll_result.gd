class_name DiceRollResult
extends Resource

## v5.0 DiceRollResult - Final result of a roll

@export var raw_roll: int # 1-20
@export var category: int # Using int for GameGlobals.RollCategory
@export var modifier: RunModifier
@export var context: DiceContext
@export var was_stored: bool = false
