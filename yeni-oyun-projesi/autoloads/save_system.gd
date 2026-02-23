class_name SaveSystem
extends Node

## v5.0 SaveSystem - JSON Persistence
## Responsibility: Saving and loading meta/run data.
## Constraint: No gameplay logic, only persistence.

const META_SAVE_PATH = "user://meta.json"
const RUN_SAVE_PATH = "user://current_run.json"

func save_meta(data: Dictionary) -> void:
	_save_json(META_SAVE_PATH, data)

func load_meta() -> Dictionary:
	return _load_json(META_SAVE_PATH)

func save_run(data: Dictionary) -> void:
	_save_json(RUN_SAVE_PATH, data)

func load_run() -> Dictionary:
	return _load_json(RUN_SAVE_PATH)

func delete_run() -> void:
	if FileAccess.file_exists(RUN_SAVE_PATH):
		DirAccess.remove_absolute(RUN_SAVE_PATH)

func _save_json(path: String, data: Dictionary) -> void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()
	else:
		push_error("[SaveSystem] Failed to save to: ", path)

func _load_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var json = JSON.parse_string(file.get_as_text())
		file.close()
		if json is Dictionary:
			return json
	
	push_error("[SaveSystem] Failed to load from: ", path)
	return {}
