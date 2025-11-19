class_name Boat
extends RigidBody2D

@export var engine_force: float = 500.0
@export var engine_max_speed: float = 1600.0
@export var absolute_max_speed: float = 3200.0
@export var base_lateral_drag: float = 5.0
@export var min_lateral_drag: float = 0.8
@export var turn_torque: float = 1300.0
@export var engine_offset: Vector2 = Vector2(-16, 0)

@export var linear_damping_factor: float = 0.985
@export var angular_damping_factor: float = 0.92

var _steer_input: float = 0.0
var _throttle: float = 0.0


func spawn_wave() -> void:
	if $WaveSpawner and $WaveSpawner.has_method("spawn_wave"):
		$WaveSpawner.spawn_wave()


func set_input(steer_input: float, throttle: float) -> void:
	_steer_input = steer_input
	_throttle = throttle


func _physics_process(_delta: float) -> void:
	# Get forward and right
	var forward: Vector2 = Vector2.RIGHT.rotated(rotation)
	var right: Vector2 = forward.rotated(-PI / 2)

	# Get forward and lateral speed
	var forward_speed: float = forward.dot(linear_velocity)
	var lateral_speed: float = right.dot(linear_velocity)

	# Engine thrust
	if (
		(_throttle > 0 and forward_speed < engine_max_speed)
		or (_throttle < 0 and forward_speed > -engine_max_speed)
	):
		var force := forward * _throttle * engine_force
		var local_engine_pos := engine_offset.rotated(rotation)
		apply_force(force, local_engine_pos)

	# Lateral drag that adapts to speed
	var speed_ratio: float = clamp(abs(forward_speed) / engine_max_speed, 0.0, 1.0)
	var current_drag: float = lerp(base_lateral_drag, min_lateral_drag, speed_ratio)
	var lateral_force: Vector2 = -right * lateral_speed * current_drag
	apply_central_force(lateral_force)

	# Steering
	apply_torque(_steer_input * turn_torque)


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	state.linear_velocity *= linear_damping_factor
	state.angular_velocity *= angular_damping_factor

	if state.linear_velocity.length() > absolute_max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * absolute_max_speed

func is_boat_infront() -> bool:
	for body in $BoatDetecter.get_overlapping_bodies():
		if body is Boat and body != self:
			return true
	return false
