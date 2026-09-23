extends CanvasLayer

@export var game: Node2D
@export var spawner: Node2D
@export var player: CharacterBody2D

@export var kills_label: Label
@export var time_label: Label
@export var level_label: Label

var is_dead: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

# Called when the node enters the scene tree for the first time.
func show_death_screen() -> void:
	
	kills_label.text = "Kills: " + str(spawner.kills)
	level_label.text = "Level: " + str(player.level)
	
	var total_seconds := int(game.elapsed_time)
	var minutes := total_seconds / 60
	var seconds := total_seconds % 60
	
	time_label.text = "Time: %d:%02d" % [minutes, seconds]
	is_dead = true

	visible = true
	get_tree().paused = true
	# visual and sound effects here...


func _unhandled_input(event: InputEvent) -> void:
	if not is_dead:
		return

	if event.is_action_pressed("ui_accept"):
		get_tree().paused = false
		get_tree().reload_current_scene()
