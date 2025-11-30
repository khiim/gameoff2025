class_name AiSteering
extends NavigationAgent2D

@export var boat: Boat
@export var targets: Array[Node2D]

@export var wave_cooldown_time: float = 2.0

var wave_cooldown: float = 0.0
var _target_index: int = 0

var _last_pos: Vector2
var _last_pos_equal_counter: int = 0
var _reverse_mode_counter: int = 0


func steer_toward(target_point: Vector2) -> void:
	var to_target: Vector2 = target_point - boat.global_position
	var desired_angle: float = to_target.angle()
	var angle_diff: float = wrapf(desired_angle - boat.rotation, -PI, PI)

	var steer_input: float = 0
	steer_input = clamp(angle_diff, -1.0, 1.0)
	var throttle = 1.0 if abs(angle_diff) < 0.5 else 0.5

	if _reverse_mode_counter > 0:
		_reverse_mode_counter -= 1
		throttle = -0.5

	boat.set_input(steer_input, throttle)


func _ready() -> void:
	# Setup NavigationAgent2D properties
	path_desired_distance = 150
	target_desired_distance = 250
	path_max_distance = 100

	avoidance_enabled = true

	# Setup first target
	if targets.size() > 0:
		target_position = targets[_target_index].global_position

	_last_pos = boat.global_position


func _physics_process(_delta: float) -> void:
	if wave_cooldown > 0:
		wave_cooldown -= _delta

	if is_navigation_finished():
		_target_index = (_target_index + 1) % targets.size()
		target_position = targets[_target_index].global_position

	var next_path_pos := get_next_path_position()
	steer_toward(next_path_pos)
	if boat.is_boat_infront() and wave_cooldown <= 0:
		wave_cooldown = wave_cooldown_time
		boat.spawn_wave()

	if boat.global_position.is_equal_approx(_last_pos):
		_last_pos_equal_counter += 1
	else:
		_last_pos = boat.global_position
		_last_pos_equal_counter = 0

	if _last_pos_equal_counter > 10:
		print("Activating reverse mode for ", boat.name)
		_reverse_mode_counter = 60
