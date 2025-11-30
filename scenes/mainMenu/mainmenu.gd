extends Node2D

var button_type = null

func _on_start_pressed() -> void:
	button_type = "start"
	_fade_trans_in()

func _on_options_pressed() -> void:
	button_type = "options"
	_fade_trans_in()
	get_tree().change_scene_to_file("res://scenes/maps/racetrack.tscn")

func _on_credits_pressed() -> void:
	button_type = "credits"
	_fade_trans_in()
	get_tree().change_scene_to_file("res://scenes/maps/racetrack.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
	
func _fade_trans_in() -> void:
	$FadeTransition.show()
	$FadeTransition/FadeTimer.start()
	$FadeTransition/AnimationPlayer.play("fade_in")


func _on_fade_timer_timeout() -> void:
	match button_type:
		"start":
			get_tree().change_scene_to_file("res://scenes/maps/racetrack.tscn")
		"options":
			get_tree().change_scene_to_file("res://scenes/maps/racetrack.tscn")
		"credits":
			get_tree().change_scene_to_file("res://scenes/maps/racetrack.tscn")
