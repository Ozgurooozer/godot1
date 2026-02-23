class_name EventBus
extends Node

## v5.0 Global EventBus - Single Source of Signals
## Scoped by prefix: combat_, run_, dice_, entity_, ui_, meta_, infra_

# COMBAT
signal combat_damage_requested(entity_id: StringName, amount: float)
signal combat_health_changed(entity_id: StringName, new_val: float)
signal combat_entity_died(entity_id: StringName)
signal combat_hit_landed(attacker_id: StringName, target_id: StringName)

# RUN STATE
signal run_started(seed: int)
signal run_ended(result: Dictionary) # Placeholder for RunResult resource
signal run_modifier_applied(modifier: Resource) # Placeholder for RunModifier resource
signal run_level_entered(level_data: Resource) # Placeholder for RoomData resource

# DICE
signal dice_roll_requested(context: Resource) # Placeholder for DiceContext resource
signal dice_roll_completed(result: Resource) # Placeholder for DiceRollResult resource
signal dice_modifier_generated(modifier: Resource) # Placeholder for RunModifier resource
signal dice_stored_added(dice: Resource) # Placeholder for StoredDice resource
signal dice_stored_consumed(dice: Resource, context: StringName)

# ENTITY
signal entity_registered(entity_id: StringName, node: Node3D)
signal entity_unregistered(entity_id: StringName)
signal entity_spawned(entity_id: StringName, data: Resource) # Placeholder for CharacterData

# UI
signal ui_scene_ready()
signal ui_dialogue_started(entry: Resource) # Placeholder for DialogueEntry
signal ui_dialogue_ended()
signal ui_dice_animation_requested(roll: int, modifier: Resource)

# META
signal meta_game_state_changed(state: int) # Using int for GameManager.GameState enum
signal meta_game_mode_changed(mode: int) # Using int for GameManager.GameMode enum
signal meta_scene_load_started(path: String)

# INFRA
signal infra_save_requested()
signal infra_audio_play_sfx(audio_data: Resource, pos: Vector3)
signal infra_audio_play_music(audio_data: Resource)
signal infra_input_mode_changed(mode: int) # Using int for InputRouter.InputMode enum
