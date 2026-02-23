extends Control

## Visual Debug UI for Phase 2C Testing
## Now shows RAW → FINAL pipeline

@onready var seed_label: Label = $VBoxContainer/SeedLabel
@onready var log_text: RichTextLabel = $VBoxContainer/LogText
@onready var roll_level_btn: Button = $VBoxContainer/ButtonsContainer/RollLevelBtn
@onready var roll_combat_btn: Button = $VBoxContainer/ButtonsContainer/RollCombatBtn
@onready var roll_loot_btn: Button = $VBoxContainer/ButtonsContainer/RollLootBtn
@onready var roll_stored_btn: Button = $VBoxContainer/ButtonsContainer/RollStoredBtn
@onready var new_run_btn: Button = $VBoxContainer/NewRunBtn
@onready var test_finalized_btn: Button = $VBoxContainer/TestFinalizedBtn

var game_manager: GameManager
var dice_domain: DiceDomain
var current_seed: int = 0

func _ready() -> void:
	# Create systems
	game_manager = GameManager.new()
	dice_domain = DiceDomain.new()
	add_child(game_manager)
	add_child(dice_domain)
	
	# Connect signals
	EventBus.run_started.connect(_on_run_started)
	EventBus.dice_roll_result.connect(_on_dice_roll_result)
	EventBus.dice_roll_finalized.connect(_on_dice_roll_finalized)
	
	# Connect buttons
	new_run_btn.pressed.connect(_on_new_run_pressed)
	roll_level_btn.pressed.connect(_on_roll_level_pressed)
	roll_combat_btn.pressed.connect(_on_roll_combat_pressed)
	roll_loot_btn.pressed.connect(_on_roll_loot_pressed)
	roll_stored_btn.pressed.connect(_on_roll_stored_pressed)
	test_finalized_btn.pressed.connect(_on_test_finalized_pressed)
	
	# Disable roll buttons until run starts
	_set_roll_buttons_enabled(false)
	
	_add_log("[color=yellow]Phase 2C Debug UI Ready[/color]")
	_add_log("[color=cyan]RAW → FINAL pipeline active[/color]")
	_add_log("Click 'Start New Run' to begin")

func _on_new_run_pressed() -> void:
	game_manager.start_new_run()
	_add_log("\n[color=cyan]Starting new run...[/color]")

func _on_roll_level_pressed() -> void:
	EventBus.dice_roll_requested.emit(DiceRollRequestPayload.new(GameGlobals.DiceStream.LEVEL))

func _on_roll_combat_pressed() -> void:
	EventBus.dice_roll_requested.emit(DiceRollRequestPayload.new(GameGlobals.DiceStream.COMBAT))

func _on_roll_loot_pressed() -> void:
	EventBus.dice_roll_requested.emit(DiceRollRequestPayload.new(GameGlobals.DiceStream.LOOT))

func _on_roll_stored_pressed() -> void:
	EventBus.dice_roll_requested.emit(DiceRollRequestPayload.new(GameGlobals.DiceStream.STORED_DICE))

func _on_test_finalized_pressed() -> void:
	# Manual test: emit a finalized result
	_add_log("\n[color=magenta]Testing FINALIZED signal...[/color]")
	var payload := FinalDiceResultPayload.new(
		GameGlobals.DiceStream.COMBAT,
		15,  # raw
		18,  # modified (+3 bonus)
		false
	)
	EventBus.dice_roll_finalized.emit(payload)

func _on_run_started(payload: RunStartPayload) -> void:
	current_seed = payload.root_seed
	seed_label.text = "Current Seed: %d" % current_seed
	_add_log("[color=green]✓ Run started with seed: %d[/color]" % current_seed)
	_set_roll_buttons_enabled(true)

func _on_dice_roll_result(payload: DiceRollResultPayload) -> void:
	var stream_name := _get_stream_name(payload.stream)
	var color := _get_stream_color(payload.stream)
	var crit_text := " [color=yellow]★ CRIT![/color]" if payload.is_crit else ""
	
	_add_log("[color=%s]  🎲 RAW [%s]: %d%s[/color]" % [color, stream_name, payload.result_value, crit_text])

func _on_dice_roll_finalized(payload: FinalDiceResultPayload) -> void:
	var stream_name := _get_stream_name(payload.stream)
	var color := _get_stream_color(payload.stream)
	var crit_text := " [color=yellow]★ CRIT![/color]" if payload.is_crit else ""
	var modifier_text := ""
	
	if payload.modified_value != payload.raw_value:
		var diff := payload.modified_value - payload.raw_value
		var sign := "+" if diff > 0 else ""
		modifier_text = " [color=white](%s%d)[/color]" % [sign, diff]
	
	_add_log("[color=%s]  ✨ FINAL [%s]: %d%s%s[/color]" % [color, stream_name, payload.modified_value, modifier_text, crit_text])

func _add_log(text: String) -> void:
	log_text.append_text(text + "\n")

func _set_roll_buttons_enabled(enabled: bool) -> void:
	roll_level_btn.disabled = not enabled
	roll_combat_btn.disabled = not enabled
	roll_loot_btn.disabled = not enabled
	roll_stored_btn.disabled = not enabled

func _get_stream_name(stream: GameGlobals.DiceStream) -> String:
	match stream:
		GameGlobals.DiceStream.LEVEL: return "LEVEL"
		GameGlobals.DiceStream.COMBAT: return "COMBAT"
		GameGlobals.DiceStream.LOOT: return "LOOT"
		GameGlobals.DiceStream.STORED_DICE: return "STORED"
		_: return "UNKNOWN"

func _get_stream_color(stream: GameGlobals.DiceStream) -> String:
	match stream:
		GameGlobals.DiceStream.LEVEL: return "aqua"
		GameGlobals.DiceStream.COMBAT: return "red"
		GameGlobals.DiceStream.LOOT: return "gold"
		GameGlobals.DiceStream.STORED_DICE: return "lime"
		_: return "white"
