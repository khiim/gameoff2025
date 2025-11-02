extends RigidBody2D

@export var engine_force: float = 400.0
@export var max_speed: float = 600.0
@export var turn_torque: float = 800.0
@export var lateral_drag: float = 5.0


func _physics_process(_delta: float) -> void:
	# Input
	var steer_input := Input.get_axis("turn_left", "turn_right")

	var throttle := 0.0
	if Input.is_action_pressed("accelerate"):
		throttle = 1.0
	elif Input.is_action_pressed("reverse"):
		throttle = -0.5

	# Get forward and right
	var forward := Vector2.RIGHT.rotated(rotation)
	var right := forward.rotated(-PI / 2)

	# Limit forward speed
	var forward_speed := forward.dot(linear_velocity)
	if abs(forward_speed) < max_speed:
		apply_central_force(forward * throttle * engine_force)

	# Lateral drag
	var lateral_speed := right.dot(linear_velocity)
	var lateral_force: Vector2 = -right * lateral_speed * lateral_drag
	apply_central_force(lateral_force)

	# Steering
	var steer_strength: float = clamp(forward_speed / max_speed, -1.0, 1.0)
	apply_torque(steer_input * turn_torque * steer_strength)
