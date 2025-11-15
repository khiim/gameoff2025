extends Node2D

var _boat_next_waypoint: Dictionary[String, int] = {}
var _boat_lap: Dictionary[String, int] = {}
var _number_of_waypoints: int = 0

@onready var boats: Node2D = $Boats
@onready var waypoints: Node2D = $Waypoints


func _ready() -> void:
	var all_waypoints = waypoints.find_children("*", "Waypoint")
	_number_of_waypoints = all_waypoints.size()

	var all_boats = boats.find_children("*", "Boat")
	for boat in all_boats:
		_boat_next_waypoint[boat.name] = 0
		_boat_lap[boat.name] = 0


func _on_waypoint_boat_reached_waypoint(boat: Boat, number: int) -> void:
	if _boat_next_waypoint[boat.name] == number:
		print(boat.name, " reached ", number)
		if number == _number_of_waypoints - 1:
			_boat_lap[boat.name] += 1
			print(boat.name, " lap ", _boat_lap[boat.name], " completed")
			_boat_next_waypoint[boat.name] = 0
		else:
			_boat_next_waypoint[boat.name] += 1
