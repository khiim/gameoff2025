class_name VictoryScreen
extends CanvasLayer

const VICTORY_SCREEN = preload("uid://cn20cyt11evvr")

var _world: World

@onready var header: RichTextLabel = %Header
@onready var boats: RichTextLabel = %Boats


static func create(world: World) -> VictoryScreen:
	var instance := VICTORY_SCREEN.instantiate()
	instance._world = world
	return instance


func _ready() -> void:
	header.clear()
	if _world._finished[0] == "Player":
		header.append_text("VICTORY")
	else:
		header.append_text("GAME OVER")
	update_list()


func update_list() -> void:
	var finished_boats := _world._finished
	boats.clear()
	for i in range(0, finished_boats.size()):
		var time_now = _world._boat_lap_times[finished_boats[i]][
			_world._boat_lap_times[finished_boats[i]].size() - 1
		]
		var time_elapsed = _world._format_time(time_now - _world._start_time)
		boats.append_text(str(i + 1) + ". " + finished_boats[i] + " : " + time_elapsed + "\n")
