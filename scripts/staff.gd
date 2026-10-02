extends Node2D

@onready var projectile_launcher: ProjectileLauncher = $ProjectileLauncher

@export var attack_interval: float = 1.0

var can_attack := true


func _process(_delta: float) -> void:
	if can_attack:
		attack()


func attack() -> void:
	can_attack = false

	var nearest_enemy = get_nearest_enemy()

	if nearest_enemy:
		var direction: Vector2 = (
			nearest_enemy.global_position - global_position
		).normalized()

		projectile_launcher.launch(direction)

	await get_tree().create_timer(attack_interval).timeout
	can_attack = true


func get_nearest_enemy() -> CharacterBody2D:
	var enemies = get_tree().get_nodes_in_group("enemy")
	var nearest_enemy: CharacterBody2D = null
	var shortest_distance := INF

	for enemy in enemies:
		var distance_sq = global_position.distance_squared_to(enemy.global_position)

		if distance_sq < shortest_distance:
			shortest_distance = distance_sq
			nearest_enemy = enemy

	return nearest_enemy
