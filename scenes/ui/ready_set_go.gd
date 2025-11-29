class_name ReadySetGo
extends CanvasLayer

signal go

@onready var ready_sprite: Sprite2D = $Ready
@onready var set_sprite: Sprite2D = $Set
@onready var go_sprite: Sprite2D = $Go


func _ready() -> void:
	start_ready()


func animate_sprite(sprite: Sprite2D) -> Tween:
	sprite.visible = true
	var tween := get_tree().create_tween()
	tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(sprite, "modulate", Color(1.0, 0.5, 0.0, 1.0), 0.5).set_trans(
		Tween.TRANS_LINEAR
	)
	tween.tween_property(sprite, "modulate", Color(1.0, 0.5, 0.0, 0.0), 0.1)
	return tween


func start_ready() -> void:
	var tween := animate_sprite(ready_sprite)
	tween.finished.connect(start_set)


func start_set() -> void:
	var tween := animate_sprite(set_sprite)
	tween.finished.connect(start_go)


func start_go() -> void:
	var tween := animate_sprite(go_sprite)
	tween.finished.connect(_on_finished)


func _on_finished() -> void:
	go.emit()
	visible = false
	queue_free()
