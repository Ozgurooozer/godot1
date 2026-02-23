extends Node

## v5.0 Integration Test Script
## Responsibility: Verify core flow: Start -> Roll -> Damage -> UI.

func _ready() -> void:
	print("--- v5.0 Integration Test Starting ---")
	
	# 1. Bootstrap check
	if not GameManager.instance:
		push_error("GameManager instance not found!")
		return
	
	# 2. Start Run
	GameManager.instance.start_new_run()
	
	# 3. Dice Roll Test
	var context := DiceContext.new()
	context.context_type = DiceContext.ContextType.COMBAT_START
	context.luck_value = 5.0
	GameManager.instance.dice_domain.roll_for_context(context)
	
	# 4. Damage Calculation Test
	var base_dmg := 10.0
	var final_dmg := GameManager.instance.combat_domain.calculate_damage(base_dmg, &"player")
	print("[Test] Base Damage: %f, Final Damage with Modifiers: %f" % [base_dmg, final_dmg])
	
	# 5. Health Component Mirror Test
	var health_comp := HealthComponent.new()
	health_comp.owner_id = &"player"
	add_child(health_comp)
	
	print("[Test] Requesting 20 damage...")
	health_comp.request_damage(20.0)
	
	# 6. Stored Dice Test
	GameManager.instance.stored_dice_system.try_drop_dice(10.0)
	
	print("--- v5.0 Integration Test Completed ---")
