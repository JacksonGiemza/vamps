extends Area2D

var direction: Vector2 = Vector2.ZERO
var speed: float = 0.0
var damage: int = 0

@export var lifetime: float = 3.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)

	await get_tree().create_timer(lifetime).timeout
	queue_free()


func _process(delta: float) -> void:
	global_position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.take_damage(damage)
		queue_free()
