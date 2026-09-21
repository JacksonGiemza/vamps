extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func show_death_screen() -> void:
	visible = true
	get_tree().paused = true
	# visual and sound effects here...


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		get_tree().paused = false
		get_tree().reload_current_scene()
