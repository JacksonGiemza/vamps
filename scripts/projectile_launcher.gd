class_name ProjectileLauncher
extends Node2D

@export var projectile_scene: PackedScene

@export var damage: int = 1
@export var projectile_speed: float = 400.0


func launch(direction: Vector2) -> void:
	var projectile = projectile_scene.instantiate()

	projectile.damage = damage
	projectile.speed = projectile_speed
	projectile.direction = direction

	get_tree().current_scene.add_child(projectile)
	projectile.global_position = global_position
