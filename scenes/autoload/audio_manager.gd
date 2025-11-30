extends Node

var _music_muted: bool = false
var _sound_muted: bool = false
var _music_idx: int
var _sound_idx: int


func _ready() -> void:
	_music_idx = AudioServer.get_bus_index("Music")
	_sound_idx = AudioServer.get_bus_index("SFX")


func toggle_sound() -> void:
	_sound_muted = !_sound_muted
	print("Toggling sound mute ", _sound_muted)
	AudioServer.set_bus_mute(_sound_idx, _sound_muted)


func toggle_music() -> void:
	_music_muted = !_music_muted
	print("Toggling music mute ", _music_muted)
	AudioServer.set_bus_mute(_music_idx, _music_muted)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_sound"):
		toggle_sound()
	elif event.is_action_pressed("toggle_music"):
		toggle_music()
