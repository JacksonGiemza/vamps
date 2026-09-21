extends Area2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	# 1. Keep the sword collision turned off until an attack starts
	collision_shape.disabled = true
	
	# 2. Connect the built-in signal to detect when something touches the sword
	body_entered.connect(_on_body_entered)

func attack() -> void:
	# Turn the collision on so it can register hits during the swing
	collision_shape.disabled = false
	
	# Create a quick visual swing animation
	var tween = create_tween()
	rotation = -0.5 
	tween.tween_property(self, "rotation", 0.5, 0.15) 
	
	# Wait for the swing to end, then turn the collision back off
	await tween.finished
	collision_shape.disabled = false
	rotation = 0.0

@export var xp: PackedScene
@export var min_xp_drops: int = 3
@export var max_xp_drops: int = 6

func _on_body_entered(body: Node2D) -> void:
	# 3. Check if the body we bumped into is in our enemy group
	if body.is_in_group("enemy"):
		body.die() 
