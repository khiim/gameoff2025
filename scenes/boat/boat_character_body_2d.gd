class_name Boat
extends CharacterBody2D

@export var acceleration: float = 400.0
@export var absolute_max_speed: float = 600.0
@export var engine_max_speed: float = 600.0
@export var turn_speed: float = 4.0
@export var linear_damping: float = 0.98
@export var lateral_drag: float = 0.2

var _impulse_force: Vector2 = Vector2.ZERO


func add_impulse(force: Vector2) -> void:
	_impulse_force += force


func _physics_process(delta: float) -> void:
	if !_impulse_force.is_zero_approx():
		velocity += _impulse_force
		_impulse_force = Vector2.ZERO

	var steer_input := Input.get_axis("turn_left", "turn_right")

	# Throttle
	var throttle := 0.0
	if Input.is_action_pressed("accelerate"):
		throttle = 1.0
	elif Input.is_action_pressed("reverse"):
		throttle = -0.5

	# Calculate forward
	var forward = Vector2.RIGHT.rotated(rotation)

	# Forward speed
	var forward_speed := velocity.dot(forward)

	# Only accelerate if we are below the engine_max_speed in the direction we are facing
	if (
		(throttle > 0 and forward_speed < engine_max_speed)
		or (throttle < 0 and forward_speed > -engine_max_speed)
	):
		velocity += forward * throttle * acceleration * delta

	# Turn based on speed
	var speed_factor = clamp(abs(forward_speed) / engine_max_speed, 0.2, 1.0)

	# Need to reverse the speed_factor when backing
	if forward_speed < 0:
		speed_factor = -speed_factor

	rotation += steer_input * turn_speed * speed_factor * delta

	# Lateral drag — kill sideways motion
	var right = forward.rotated(-PI / 2)
	var lateral_vel = right.dot(velocity)
	velocity -= right * lateral_vel * lateral_drag

	# Apply damping
	velocity *= linear_damping

	# Cap maximum speed
	if velocity.length() > absolute_max_speed:
		velocity = velocity.normalized() * absolute_max_speed

	if move_and_slide():
		velocity = get_real_velocity()
