extends RefCounted
class_name RunStartPayload

## Run start event payload
## Used when new run is started with root seed

var root_seed: int

func _init(p_root_seed: int) -> void:
	assert(p_root_seed != 0, "Seed cannot be 0")
	root_seed = p_root_seed