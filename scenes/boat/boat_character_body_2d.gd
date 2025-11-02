extends CharacterBody2D

@export var acceleration: float = 400.0
@export var max_speed: float = 600.0
@export var turn_speed: float = 4.0
@export var linear_damping: float = 0.98
@export var lateral_drag: float = 0.2


func _physics_process(delta: float) -> void:
	var steer_input := Input.get_axis("turn_left", "turn_right")

	# Throttle
	var throttle := 0.0
	if Input.is_action_pressed("accelerate"):
		throttle = 1.0
	elif Input.is_action_pressed("reverse"):
		throttle = -0.5

	# Apply forward acceleration
	var forward = Vector2.RIGHT.rotated(rotation)
	velocity += forward * throttle * acceleration * delta

	# Cap speed
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed

	# Turn based on speed (no steering if stopped)
	var speed_factor = clamp(velocity.length() / max_speed, 0.0, 1.0)
	if velocity.normalized().dot(forward) < 0:
		speed_factor = -speed_factor
	rotation += steer_input * turn_speed * speed_factor * delta

	# Lateral drag — kill sideways motion
	var right = forward.rotated(-PI / 2)
	var lateral_vel = right.dot(velocity)
	velocity -= right * lateral_vel * lateral_drag

	# Apply damping
	velocity *= linear_damping

	move_and_slide()
