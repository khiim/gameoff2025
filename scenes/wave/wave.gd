class_name Wave
extends Area2D

const WAVE = preload("uid://17k81a73kbas")

var _original_scale := Vector2.ONE
var _current_scale := Vector2.ONE
var _wave_origin := Vector2.ZERO

var _force: float
var _expansion_rate: float = 100
var _hit_boats: Array[Boat] = []

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


static func create(pos: Vector2, force: float) -> Wave:
	var instance: Wave = WAVE.instantiate()
	instance.global_position = pos
	instance._force = force
	return instance


func _ready() -> void:
	_original_scale = collision_shape_2d.scale
	_current_scale = _original_scale
	_wave_origin = global_position


func _physics_process(delta: float) -> void:
	_current_scale += Vector2(_expansion_rate * delta, _expansion_rate * delta)
	collision_shape_2d.scale = _original_scale * _current_scale

	for boat in _hit_boats:
		if is_instance_valid(boat):
			var direction_to_boat := boat.global_position - _wave_origin
			var force = direction_to_boat.normalized() * (_current_scale.x / 2.0) * _force

			boat.add_impulse(force)

	_hit_boats.clear()

	if _current_scale.length() > 100:
		print("Freeing wave")
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Boat:
		_hit_boats.append(body)
		print("hit body", body)
