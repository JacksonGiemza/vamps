extends Area2D
@onready var sprite: AnimatedSprite2D = $Slash
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


# Weapon stats 
@export var attack_interval: float = 1.0
@export var attack_speed: float = 1.0
@export var damage: int = 1

var can_attack := true


func _ready() -> void:
	collision_shape.disabled = true
	sprite.visible = false
	
	body_entered.connect(_on_body_entered)
	sprite.animation_finished.connect(_on_animation_finished)
	

func _process(_delta: float) -> void:
	if can_attack:
		attack()


func attack() -> void:
	can_attack = false
	
	# Show weapon and activate hitbox
	sprite.visible = true
	collision_shape.disabled = false
	
	# Play attack animation
	sprite.speed_scale = attack_speed
	sprite.play("attack")


func _on_animation_finished() -> void:
	# Attack is over
	sprite.stop()
	sprite.visible = false
	collision_shape.disabled = true
	
	# Wait before allowing another attack
	await get_tree().create_timer(attack_interval).timeout
	
	can_attack = true


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.take_damage(damage)


# -------------------------
# Upgrade
# -------------------------

func upgrade_damage(amount: int) -> void:
	damage += amount


func upgrade_attack_speed(amount: float) -> void:
	attack_interval *= amount
