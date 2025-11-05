extends Camera2D

@export var target_nodes: Array[NodePath] = []
@export var follow_speed: float = 5.0
@export var zoom_min: float = 0.5
@export var zoom_max: float = 1.2
@export var zoom_margin: float = 400.0


func _process(delta):
	if target_nodes.is_empty():
		return

	var positions: Array[Vector2] = []
	for path in target_nodes:
		var node = get_node_or_null(path)
		if node:
			positions.append(node.global_position)

	if positions.is_empty():
		return

	var center = Vector2.ZERO
	for pos in positions:
		center += pos
	center /= positions.size()

	global_position = lerp(global_position, center, delta * follow_speed)

	if positions.size() > 1:
		var max_distance = 0.0
		for p in positions:
			for q in positions:
				max_distance = max(max_distance, p.distance_to(q))
		var zoom_factor = clamp(zoom_margin / max_distance, zoom_min, zoom_max)
		zoom = Vector2(zoom_factor, zoom_factor)
