class_name DataRegistry
extends Node

## v5.0 DataRegistry - Central Resource Cache
## Responsibility: Loading and caching resources.
## Constraint: No gameplay logic, only storage and access.

var _resource_cache: Dictionary = {} # StringName -> Resource

func get_resource(path: String) -> Resource:
	if _resource_cache.has(path):
		return _resource_cache[path]
	
	var res := load(path)
	if res:
		_resource_cache[path] = res
		return res
	
	push_error("[DataRegistry] Failed to load resource: ", path)
	return null

func get_character(id: String) -> CharacterData:
	return get_resource("res://data/characters/chr_" + id + ".tres") as CharacterData

func get_weapon(id: String) -> Resource: # Placeholder for WeaponData
	return get_resource("res://data/weapons/wpn_" + id + ".tres")
