extends PathFollow2D

@export var speed: float = 20


func _process(delta: float) -> void:
	progress += speed * delta
