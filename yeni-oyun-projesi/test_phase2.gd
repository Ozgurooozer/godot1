extends Node

## Phase 2B Live Test
## Simple test without GUT framework

func _ready() -> void:
	print("\n=== PHASE 2B LIVE TEST ===\n")
	
	# Connect to signals
	EventBus.run_started.connect(_on_run_started)
	EventBus.dice_roll_result.connect(_on_dice_roll_result)
	
	# Wait a frame
	await get_tree().process_frame
	
	# Create and add GameManager
	var game_manager := GameManager.new()
	add_child(game_manager)
	
	# Create and add DiceDomain
	var dice_domain := DiceDomain.new()
	add_child(dice_domain)
	
	# Wait for _ready
	await get_tree().process_frame
	
	print("Starting new run...")
	game_manager.start_new_run()
	
	await get_tree().create_timer(0.5).timeout
	
	print("\nRolling dice on COMBAT stream...")
	EventBus.dice_roll_requested.emit(DiceRollRequestPayload.new(GameGlobals.DiceStream.COMBAT))
	
	await get_tree().create_timer(0.3).timeout
	
	print("\nRolling dice on LEVEL stream...")
	EventBus.dice_roll_requested.emit(DiceRollRequestPayload.new(GameGlobals.DiceStream.LEVEL))
	
	await get_tree().create_timer(0.3).timeout
	
	print("\nRolling 5 times on LOOT stream...")
	for i in range(5):
		EventBus.dice_roll_requested.emit(DiceRollRequestPayload.new(GameGlobals.DiceStream.LOOT))
		await get_tree().create_timer(0.1).timeout
	
	await get_tree().create_timer(0.5).timeout
	
	print("\n=== TEST COMPLETE ===\n")

func _on_run_started(payload: RunStartPayload) -> void:
	print("✅ Run started with seed: %d" % payload.root_seed)

func _on_dice_roll_result(payload: DiceRollResultPayload) -> void:
	var stream_name := _get_stream_name(payload.stream)
	var crit := " 🎲 CRIT!" if payload.is_crit else ""
	print("  🎲 [%s] Roll: %d%s" % [stream_name, payload.result_value, crit])

func _get_stream_name(stream: GameGlobals.DiceStream) -> String:
	match stream:
		GameGlobals.DiceStream.LEVEL: return "LEVEL"
		GameGlobals.DiceStream.COMBAT: return "COMBAT"
		GameGlobals.DiceStream.LOOT: return "LOOT"
		GameGlobals.DiceStream.STORED_DICE: return "STORED"
		_: return "UNKNOWN"
