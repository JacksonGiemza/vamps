extends CanvasLayer

@export var game: Node2D
@export var player: CharacterBody2D
@export var spawner: Node2D

@onready var health_label: Label = $MarginContainer/VBoxContainer/Health
@onready var xp_label: Label = $MarginContainer/VBoxContainer/XP
@onready var level_label: Label = $MarginContainer/VBoxContainer/Level
@onready var kills_label: Label = $MarginContainer/VBoxContainer/Kills
@onready var time_label: Label = $MarginContainer/VBoxContainer/Time

func _ready():
	update_health(100)
	update_xp(0)
	update_level(1)
	update_kills(0)
	update_time(0)
	
	player.xp_changed.connect(update_xp)
	update_xp(player.xp)
	
	player.health_change.connect(update_health)
	update_health(player.health)
	
	player.level_changed.connect(update_level)
	update_level(player.level)
	
	spawner.kills_changed.connect(update_kills)
	update_kills(spawner.kills)


func _process(_delta: float) -> void:
	update_time(game.elapsed_time)

func update_health(health: int):
	health_label.text = "Health: " + str(health)


func update_xp(xp: int):
	xp_label.text = "XP: " + str(xp)


func update_level(level: int):
	level_label.text = "Level: " + str(level)


func update_kills(kills: int):
	kills_label.text = "Kills: " + str(kills)


func update_time(seconds: float) -> void:
	var total_seconds := int(seconds)
	var minutes := total_seconds / 60
	var remaining_seconds := total_seconds % 60

	time_label.text = "Time: %d:%02d" % [minutes, remaining_seconds]
