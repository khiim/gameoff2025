extends Node2D

signal player_finished(place: int)

@export var laps: int = 3

var _boat_next_waypoint: Dictionary[String, int] = {}
var _boat_lap: Dictionary[String, int] = {}
var _number_of_waypoints: int = 0
var _waypoint_markers: Array[Node2D] = []
var _finished: Array[String] = []
var _player_finished: bool = false
var _player_place: int = 0
var _all_boats: Array[Boat] = []

@onready var boats: Node2D = %Boats
@onready var waypoints: Node2D = %Waypoints
@onready var player: Boat = %Player
@onready var status_label: RichTextLabel = %StatusRichTextLabel
@onready var ready_set_go: ReadySetGo = $ReadySetGo


func _ready() -> void:
	ready_set_go.go.connect(_on_go)
	var all_waypoints := waypoints.find_children("*", "Waypoint")
	_number_of_waypoints = all_waypoints.size()

	for waypoint in all_waypoints:
		if waypoint is Node2D:
			_waypoint_markers.append(waypoint)

	var all_boats = boats.find_children("*", "Boat")
	for boat in all_boats:
		if boat is Boat:
			_all_boats.append(boat)
			if boat.has_node("AiSteering"):
				boat.get_node("AiSteering").targets = _waypoint_markers
		_boat_next_waypoint[boat.name] = 0
		_boat_lap[boat.name] = 0

	_update_laps()
	boats.process_mode = Node.PROCESS_MODE_DISABLED


func _on_go() -> void:
	boats.process_mode = Node.PROCESS_MODE_INHERIT


func _on_waypoint_boat_reached_waypoint(boat: Boat, number: int) -> void:
	if _boat_next_waypoint[boat.name] == number:
		print(boat.name, " reached ", number)
		if number == _number_of_waypoints - 1:
			if _boat_lap[boat.name] == laps - 1:
				_boat_finished(boat)
			else:
				_boat_lap[boat.name] += 1

			_update_laps()
			print(boat.name, " lap ", _boat_lap[boat.name], " completed")
			_boat_next_waypoint[boat.name] = 0
		else:
			_boat_next_waypoint[boat.name] += 1


func _update_laps() -> void:
	var player_lap: int = _boat_lap[player.name]

	status_label.clear()
	status_label.push_bold()
	status_label.append_text("Lap ")
	status_label.append_text(str(player_lap + 1))
	status_label.append_text("/")
	status_label.append_text(str(laps))

	status_label.pop_all()

	status_label.append_text("\n\n")

	if not _finished.is_empty():
		status_label.append_text("Place:\n")
		for i in range(0, _finished.size()):
			status_label.append_text(str(i + 1) + ". " + _finished[i] + "\n")


func _boat_finished(boat: Boat) -> void:
	if _finished.any(func(b: String) -> bool: return b == boat.name):
		return
	print("Boat finished ", boat.name)
	_finished.append(boat.name)
	if boat.name == player.name && !_player_finished:
		_player_finished = true
		_player_place = _finished.size()
		player_finished.emit(_player_place)
