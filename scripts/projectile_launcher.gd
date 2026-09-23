class_name ProjectileLauncher
extends Node2D

@export var projectile_scene: PackedScene

@export var damage: int = 10
@export var projectile_speed: float = 400.0


func launch(direction: Vector2) -> void:
	var projectile = projectile_scene.instantiate()

	projectile.damage = damage
	projectile.speed = projectile_speed
	projectile.direction = direction

	# We still need to:
	# 1. add it to the world
	# 2. place it at this launcher's global position
