class_name Wave
extends Area2D

const WAVE = preload("uid://17k81a73kbas")

var _original_scale := Vector2.ONE
var _current_scale := Vector2.ZERO
var _wave_origin := Vector2.ZERO
var _direction := Vector2.RIGHT

var _force: float
var _speed: float = 200.0
var _max_radius: float = 500.0
var _current_radius: float = 0.0
var _growth_rate: float = 150.0
var _fade_start_percent: float = 0.7
var _hit_boats: Array[Boat] = []

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D


static func create(pos: Vector2, direction: Vector2, force: float, speed: float = 200.0) -> Wave:
	var instance: Wave = WAVE.instantiate()
	instance.global_position = pos
	instance._direction = direction.normalized()
	instance._force = force
	instance._speed = speed
	return instance


func _ready() -> void:
	_original_scale = collision_shape_2d.scale
	_wave_origin = global_position

	if sprite and sprite.material is ShaderMaterial:
		# Shader material should be set up in the scene
		pass


func _physics_process(delta: float) -> void:
	global_position += _direction * _speed * delta
	_current_radius += _growth_rate * delta

	var scale_factor = _current_radius / 50.0
	_current_scale = Vector2.ONE * scale_factor
	collision_shape_2d.scale = _original_scale * _current_scale
	sprite.scale = collision_shape_2d.scale

	if sprite and sprite.material is ShaderMaterial:
		var fade_progress = _current_radius / _max_radius
		print("Fade progress :", fade_progress)
		sprite.material.set_shader_parameter("progress", fade_progress)
		sprite.scale = _current_scale

		var alpha = 1.0
		if fade_progress > _fade_start_percent:
			var fade_amount = (fade_progress - _fade_start_percent) / (1.0 - _fade_start_percent)
			alpha = 1.0 - fade_amount
		sprite.material.set_shader_parameter("alpha", alpha)
		sprite.material.set_shader_parameter(
			"radius", collision_shape_2d.shape.radius * collision_shape_2d.scale.x
		)
		sprite.material.set_shader_parameter("direction", _direction)

	for boat in _hit_boats:
		if is_instance_valid(boat):
			var direction_to_boat := boat.global_position - global_position
			var dot = direction_to_boat.normalized().dot(_direction)

			if dot > 0:
				var force_multiplier = 1.0
				var fade_progress = _current_radius / _max_radius

				if fade_progress > _fade_start_percent:
					var fade_amount = (
						(fade_progress - _fade_start_percent) / (1.0 - _fade_start_percent)
					)
					force_multiplier = 1.0 - fade_amount

				var impulse = direction_to_boat.normalized() * _force * force_multiplier
				boat.apply_central_impulse(impulse)

	_hit_boats.clear()

	if _current_radius > _max_radius:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Boat and body not in _hit_boats:
		_hit_boats.append(body)


func _on_body_exited(body: Node2D) -> void:
	if body is Boat:
		_hit_boats.erase(body)
