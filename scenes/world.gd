extends Node2D

signal player_finished(place: int)

@export var laps: int = 3

var _boat_next_waypoint: Dictionary[String, int] = {}
var _boat_lap: Dictionary[String, int] = {}
var _boat_lap_times: Dictionary[String, Array] = {}
var _number_of_waypoints: int = 0
var _waypoint_markers: Array[Node2D] = []
var _finished: Array[String] = []
var _player_finished: bool = false
var _player_place: int = 0
var _all_boats: Array[Boat] = []
var _start_time: float = 0

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
		_add_lap(boat, Time.get_unix_time_from_system())

	_update_laps()
	boats.process_mode = Node.PROCESS_MODE_DISABLED
	_start_time = Time.get_unix_time_from_system()


func _on_go() -> void:
	boats.process_mode = Node.PROCESS_MODE_INHERIT


func _add_lap(boat: Boat, t: float) -> void:
	if not _boat_lap_times.has(boat.name):
		_boat_lap_times[boat.name] = []
	_boat_lap_times[boat.name].append(t)


func _on_waypoint_boat_reached_waypoint(boat: Boat, number: int) -> void:
	if _boat_next_waypoint[boat.name] == number:
		print(boat.name, " reached ", number)
		if number == _number_of_waypoints - 1:
			_add_lap(boat, Time.get_unix_time_from_system())
			if _boat_lap[boat.name] == laps - 1:
				_boat_finished(boat)
			else:
				_boat_lap[boat.name] += 1

			_update_laps()
			print(boat.name, " lap ", _boat_lap[boat.name], " completed")
			_boat_next_waypoint[boat.name] = 0
		else:
			_boat_next_waypoint[boat.name] += 1


func _format_time(_seconds: float) -> String:
	var mins = int(_seconds) / 60.0
	var secs = int(_seconds) % 60
	return str(mins) + "m" + str(secs).lpad(2, "0") + "s"


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
			var time_now = _boat_lap_times[_finished[i]][_boat_lap_times[_finished[i]].size() - 1]
			var time_elapsed = _format_time(time_now - _start_time)
			status_label.append_text(str(i + 1) + ". " + _finished[i] + " : " + time_elapsed + "\n")


func _boat_finished(boat: Boat) -> void:
	if _finished.any(func(b: String) -> bool: return b == boat.name):
		return
	print("Boat finished ", boat.name)
	_finished.append(boat.name)
	if boat.name == player.name && !_player_finished:
		_player_finished = true
		_player_place = _finished.size()
		player_finished.emit(_player_place)
