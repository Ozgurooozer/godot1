class_name BoonData
extends Resource

## v5.0 BoonData - Defines a boon offered as reward

enum Rarity { COMMON, RARE, EPIC, LEGENDARY }

@export var name: String = "Boon"
@export var description: String = ""
@export var rarity: Rarity = Rarity.COMMON
@export var max_stack: int = 1

# Stat modifiers in this boon
@export var damage_modifier: float = 0.0
@export var speed_modifier: float = 0.0
@export var health_modifier: float = 0.0
@export var is_percent: bool = true
