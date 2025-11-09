class_name PlayerSteering
extends Node

@export var boat: Boat


func _physics_process(_delta: float) -> void:
	# Input
	var steer_input: float = Input.get_axis("turn_left", "turn_right")

	var throttle: float = 0.0
	if Input.is_action_pressed("accelerate"):
		throttle = 1.0
	elif Input.is_action_pressed("reverse"):
		throttle = -0.5

	if boat:
		boat.set_input(steer_input, throttle)
