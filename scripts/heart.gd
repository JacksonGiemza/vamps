extends CharacterBody2D

const SPEED := 80.0

@export var player: CharacterBody2D
var attracted := false


func _physics_process(_delta: float) -> void:
	if attracted and player:
		var direction := global_position.direction_to(player.global_position)
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()


func _on_attraction_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		attracted = true


func _on_pickup_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.add_health(10)
		queue_free()


func _on_attraction_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		attracted = false
