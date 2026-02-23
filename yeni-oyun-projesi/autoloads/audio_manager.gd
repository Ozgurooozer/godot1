class_name AudioManager
extends Node

## v5.0 AudioManager - Global SFX/Music Controller
## Responsibility: Playing sounds with 3D positioning and pooling.
## Constraint: Centralized control via EventBus.

@export var max_sfx_players: int = 16
var _sfx_pool: Array[AudioStreamPlayer3D] = []

func _ready() -> void:
	# Initialize pool
	for i in range(max_sfx_players):
		var p = AudioStreamPlayer3D.new()
		p.bus = &"SFX"
		add_child(p)
		_sfx_pool.append(p)
	
	# Connect to EventBus signals
	EventBus.infra_audio_play_sfx.connect(play_sfx)

func play_sfx(stream: AudioStream, position: Vector3 = Vector3.ZERO) -> void:
	if not stream:
		return
		
	var player = _get_available_player()
	if player:
		player.stream = stream
		player.global_position = position
		player.play()

func _get_available_player() -> AudioStreamPlayer3D:
	for p in _sfx_pool:
		if not p.playing:
			return p
	# If none available, steal the oldest one or just use the first (simple logic for now)
	return _sfx_pool[0]
