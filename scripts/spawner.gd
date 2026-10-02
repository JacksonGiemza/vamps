extends Node2D

@export var player: CharacterBody2D
const enemy_scene = preload("res://scenes/enemy.tscn")

# spawning ring boundaries
@export var min_spawn_distance: float = 400.0
@export var max_spawn_distance: float = 600.0

@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.start()

func _on_timer_timeout() -> void:
	if player != null:
		spawn_enemy_around_player()
		$Timer.wait_time -= 0.001 # really bad idea

func spawn_enemy_around_player() -> void:
	var enemy = enemy_scene.instantiate()
	enemy.died.connect(_on_enemy_died)

	# Set position
	var random_angle = randf_range(0.0, TAU) 
	var random_distance = randf_range(min_spawn_distance, max_spawn_distance)
	var spawn_offset = Vector2(cos(random_angle), sin(random_angle)) * random_distance
	enemy.global_position = player.global_position + spawn_offset
	
	# Assign the spawners player reference to the enemys player variable
	enemy.player = player
	
	# Add to the active scene
	get_tree().current_scene.add_child(enemy)

signal kills_changed(kills: int)
var kills: int = 0

func _on_enemy_died():
	kills += 1
	kills_changed.emit(kills)

func _increase_health() -> void:
	
	enemy_scene.health += 1
	enemy_scene.health_change.emit(player.health)
