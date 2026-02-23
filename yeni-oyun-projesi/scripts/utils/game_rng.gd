class_name GameRNG
extends RefCounted

## v5.0 GameRNG - Centralized RNG Utility
## Responsibility: Providing deterministic or random values.
## Constraint: Static methods where possible.

static func roll_d20() -> int:
	return (randi() % 20) + 1

static func roll_chance(chance: float) -> bool:
	return randf() < chance

static func weighted_pick(items: Array, weights: Array[float]) -> Variant:
	if items.size() != weights.size():
		push_error("[GameRNG] Items and weights size mismatch!")
		return null
		
	var total_weight: float = 0.0
	for w in weights:
		total_weight += w
		
	var r: float = randf() * total_weight
	var cumulative: float = 0.0
	for i in range(weights.size()):
		cumulative += weights[i]
		if r <= cumulative:
			return items[i]
			
	return items[0]
