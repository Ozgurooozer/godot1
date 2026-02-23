class_name GameManager
extends Node

## v5.0 GameManager - The Orchestrator
## Responsibility: Bootstrap, Dependency Wiring, Scene Lifecycle
## Constraint: Max 150 lines, no gameplay logic.

enum GameState { MAIN_MENU, HUB, TRANSITIONING, IN_ROOM, PAUSED, GAME_OVER, RUN_COMPLETE }
enum GameMode  { MODE_2D, MODE_3D }

static var instance: GameManager

var current_state: GameState = GameState.MAIN_MENU
var current_mode: GameMode  = GameMode.MODE_2D

# Domain references - Wired but not owned
var run_domain: RunDomain
var entity_registry: EntityRegistry
var dice_domain: DiceDomain
var combat_domain: CombatDomain
var stored_dice_system: StoredDiceSystem

func _ready() -> void:
	instance = self
	_bootstrap()

func _bootstrap() -> void:
	print("[GameManager] Bootstrapping v5.0...")
	
	# Instantiate and wire domains
	run_domain = _init_domain("RunDomain", RunDomain)
	entity_registry = _init_domain("EntityRegistry", EntityRegistry)
	dice_domain = _init_domain("DiceDomain", DiceDomain)
	combat_domain = _init_domain("CombatDomain", CombatDomain)
	stored_dice_system = _init_domain("StoredDiceSystem", StoredDiceSystem)
	
	EventBus.ui_scene_ready.connect(_on_ui_ready)

func _init_domain(domain_name: String, domain_class: Object) -> Node:
	var domain = get_node_or_null(domain_name)
	if not domain:
		domain = domain_class.new()
		domain.name = domain_name
		add_child(domain)
	return domain

func start_new_run() -> void:
	var seed: int = _generate_root_seed()
	EventBus.run_started.emit(seed)
	current_state = GameState.IN_ROOM

func _generate_root_seed() -> int:
	return int(Time.get_unix_time_from_system()) ^ Time.get_ticks_usec()

func _on_ui_ready() -> void:
	print("[GameManager] UI Ready, state: ", current_state)
