class_name Waypoint
extends Area2D

signal boat_reached_waypoint(boat: Boat, number: int)

@export var waypoint_number: int = 1


func _on_body_entered(body: Node2D) -> void:
	if body is Boat:
		boat_reached_waypoint.emit(body, waypoint_number)
