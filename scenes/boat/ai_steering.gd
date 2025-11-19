class_name AiSteering
extends NavigationAgent2D

@export var boat: Boat
@export var targets: Array[Node2D]

@export var min_angle_diff: float = 0.5
@export var wave_cooldown_time: float = 2.0

var wave_cooldown: float = 0.0
var _target_index: int = 0


func steer_toward(target_point: Vector2) -> void:
	var to_target: Vector2 = target_point - boat.global_position
	var desired_angle: float = to_target.angle()
	var angle_diff: float = wrapf(desired_angle - boat.rotation, -PI, PI)

	var steer_input: float = 0
	if angle_diff < min_angle_diff or angle_diff > -min_angle_diff:
		steer_input = clamp(angle_diff / PI, -1.0, 1.0)
	var throttle = 1.0 if abs(angle_diff) < 0.4 else 0.5

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
	
