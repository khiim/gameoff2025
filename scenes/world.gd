extends Node2D

var _wave_force: float = 0.0
var _max_force: float = 50


func _physics_process(delta: float) -> void:
	if Input.is_action_just_released("wave"):
		var mouse_pos = get_global_mouse_position()
		print("Force: ", _wave_force, mouse_pos)
		var wave := Wave.create(mouse_pos, _wave_force)
		_wave_force = 0.0
		add_child(wave)
	elif Input.is_action_pressed("wave"):
		_wave_force = min(_wave_force + 10 * delta, _max_force)
	else:
		_wave_force = 0.0
