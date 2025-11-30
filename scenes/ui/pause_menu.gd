extends Control


func resume():
	visible = false
	get_tree().paused = false


func pause():
	visible = true
	get_tree().paused = true


func test_pause():
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused == false:
			pause()
		else:
			resume()


func _on_resume_pressed():
	resume()


func _on_restart_pressed():
	get_tree().reload_current_scene()


func _on_quit_pressed():
	get_tree().quit()


func _process(delta):
	test_pause()


func _ready():
	visible = false
