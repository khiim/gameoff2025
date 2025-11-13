extends Node2D

## Wave Spawner
## Add this script to a Node2D in your scene (could be the player boat or a dedicated spawner)
## Press SPACEBAR to spawn waves

signal wave_spawned(wave: Wave)

@export_group("Wave Settings")
@export var wave_force: float = 500.0
@export var wave_speed: float = 200.0
@export var spawn_offset: float = 30.0  # Distance from spawner to create wave

@export_group("Input")
@export var input_action: String = "spawn_wave"  # Change to your input action name

@export_group("Direction Mode")
enum DirectionMode { FIXED, MOUSE, FORWARD, VELOCITY }  # Always spawn in a fixed direction  # Spawn towards mouse position  # Spawn in the direction this node is facing  # Spawn in the direction of movement (for moving objects)
@export var direction_mode: DirectionMode = DirectionMode.FORWARD
@export var fixed_direction: Vector2 = Vector2.RIGHT  # Used when FIXED mode

# Optional: Reference to a RigidBody2D/CharacterBody2D for VELOCITY mode
@export var movement_body: Node2D


func spawn_wave() -> void:
	var direction = _get_spawn_direction()
	var spawn_pos = global_position + direction * spawn_offset

	var wave = Wave.create(spawn_pos, direction, wave_force, wave_speed)
	get_tree().current_scene.add_child(wave)

	wave_spawned.emit(wave)

	print("Wave spawned at ", spawn_pos, " in direction ", direction)


func _get_spawn_direction() -> Vector2:
	match direction_mode:
		DirectionMode.FIXED:
			return fixed_direction.normalized()

		DirectionMode.MOUSE:
			var mouse_pos = get_global_mouse_position()
			return (mouse_pos - global_position).normalized()

		DirectionMode.FORWARD:
			# Use the node's rotation to determine forward direction
			return Vector2.RIGHT.rotated(global_rotation)

		DirectionMode.VELOCITY:
			if movement_body and movement_body is RigidBody2D:
				var vel = movement_body.linear_velocity
				if vel.length() > 0.1:
					return vel.normalized()
			elif movement_body and movement_body is CharacterBody2D:
				var vel = movement_body.velocity
				if vel.length() > 0.1:
					return vel.normalized()
			# Fallback to forward direction if no velocity
			return Vector2.RIGHT.rotated(global_rotation)

	return Vector2.RIGHT


## Call this from code to spawn a wave in a specific direction
func spawn_wave_custom(
	direction: Vector2, custom_force: float = -1.0, custom_speed: float = -1.0
) -> Wave:
	var force = custom_force if custom_force > 0 else wave_force
	var speed = custom_speed if custom_speed > 0 else wave_speed

	var spawn_pos = global_position + direction.normalized() * spawn_offset
	var wave = Wave.create(spawn_pos, direction, force, speed)
	get_tree().current_scene.add_child(wave)

	wave_spawned.emit(wave)
	return wave
