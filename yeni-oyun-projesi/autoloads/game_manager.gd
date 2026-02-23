class_name GameManager
extends Node

## v5.0 GameManager - Orchestrator
## Responsibility: State Machine, Scene Lifecycle, Dependency Wiring.
## Constraint: Max 150 lines, no gameplay logic.

enum GameState { MAIN_MENU, HUB, TRANSITIONING, IN_ROOM, PAUSED, GAME_OVER, RUN_COMPLETE }
enum GameMode  { MODE_2D, MODE_3D }

static var instance: GameManager

var current_state: GameState = GameState.MAIN_MENU
var current_mode: GameMode  = GameMode.MODE_2D

# Child systems (NOT Autoloads)
var run_domain: Node
var entity_registry: Node
var dice_domain: Node
var combat_domain: Node
var stored_dice_system: Node
var vfx_manager: Node
var audio_manager: Node

func _ready() -> void:
	instance = self
	_bootstrap()

func _bootstrap() -> void:
	print("[GameManager] Bootstrapping v5.0 Clean Version...")
	
	# Instantiate and wire child systems
	run_domain = _init_system("RunDomain", load("res://scripts/domains/run_domain.gd"))
	entity_registry = _init_system("EntityRegistry", load("res://scripts/managers/entity_registry.gd"))
	dice_domain = _init_system("DiceDomain", load("res://scripts/domains/dice_domain.gd"))
	combat_domain = _init_system("CombatDomain", load("res://scripts/domains/combat_domain.gd"))
	stored_dice_system = _init_system("StoredDiceSystem", load("res://scripts/managers/stored_dice_system.gd"))
	vfx_manager = _init_system("VFXManager", load("res://scripts/managers/vfx_manager.gd"))
	audio_manager = _init_system("AudioManager", load("res://autoloads/audio_manager.gd"))
	
	EventBus.ui_scene_ready.connect(_on_ui_ready)

func _init_system(sys_name: String, sys_class: GDScript) -> Node:
	var sys = get_node_or_null(sys_name)
	if not sys:
		sys = sys_class.new()
		sys.name = sys_name
		add_child(sys)
	return sys

func start_new_run() -> void:
	var seed: int = _generate_root_seed()
	EventBus.run_started.emit(seed)
	current_state = GameState.IN_ROOM

func _generate_root_seed() -> int:
	return int(Time.get_unix_time_from_system()) ^ Time.get_ticks_usec()

func _on_ui_ready() -> void:
	print("[GameManager] UI Ready, state: ", current_state)
