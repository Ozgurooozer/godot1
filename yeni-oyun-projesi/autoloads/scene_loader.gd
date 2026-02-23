class_name SceneLoader
extends Node

## v5.0 SceneLoader - Async Scene Transition
## Responsibility: Loading scenes without freezing the main thread.

signal loading_started(path: String)
signal loading_finished(path: String)
signal loading_progress(progress: float)

func load_scene(path: String) -> void:
	EventBus.meta_scene_load_started.emit(path)
	loading_started.emit(path)
	
	# Simple implementation for Sprint 1 (Sync load)
	# Future sprints will implement ResourceLoader.load_threaded_request()
	var scene = load(path)
	if scene:
		get_tree().change_scene_to_packed(scene)
		loading_finished.emit(path)
	else:
		push_error("[SceneLoader] Failed to load scene: ", path)
