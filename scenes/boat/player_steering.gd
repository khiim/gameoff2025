class_name PlayerSteering
extends Node

@export var boat: Boat
@export var wave_cooldown_time: float = 2.0

var wave_cooldown: float = 0.0


func _physics_process(_delta: float) -> void:
	if wave_cooldown > 0:
		wave_cooldown -= _delta
	# Input
	var steer_input: float = Input.get_axis("turn_left", "turn_right")

	var throttle: float = 0.0
	if Input.is_action_pressed("accelerate"):
		throttle = 1.0
	elif Input.is_action_pressed("reverse"):
		throttle = -0.5

	if Input.is_action_pressed("wave") and boat and wave_cooldown <= 0:
		wave_cooldown = wave_cooldown_time
		boat.spawn_wave()

	if boat:
		boat.set_input(steer_input, throttle)
