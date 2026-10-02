extends CharacterBody2D

# Enemy base stats
const SPEED = 75.0
var health: int = 2
var knockback_velocity: Vector2 = Vector2.ZERO
@export var knockback_decay: float = 1500.0 # How fast the slide stops

@export var player: CharacterBody2D
@onready var enemy_sprite: AnimatedSprite2D = $enemySprite

func _ready() -> void:
	add_to_group("enemy") 


func _physics_process(_delta: float) -> void:
	if player:
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay * _delta)
		var direction: Vector2 = (player.global_position - global_position).normalized()
		velocity = (direction * SPEED) + knockback_velocity
		
		if direction.x < 0:
			enemy_sprite.flip_h = true
		elif direction.x > 0:
			enemy_sprite.flip_h = false
			
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()


func take_damage(amount: int) -> void:
	health = max(health - amount, 0)
	
	if health == 0:
		die()
	elif player:
		var direction: Vector2 = (global_position - player.global_position).normalized()
		
		# Set a high starting force (try 400 - 600)
		knockback_velocity = direction * 500.0 

@export var xp: PackedScene
@export var min_xp_drops: int = 3
@export var max_xp_drops: int = 6
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

signal died

func die() -> void:
	
	var drop_count := randi_range(min_xp_drops, max_xp_drops)
	for i in range(drop_count):
		spawn_xp()
	
	var heart_spawn_chance = 0.10
	if randf() < heart_spawn_chance:
		spawn_heart()
	#death_sound.play()
	#await death_sound.finished
	died.emit()
	queue_free()

func spawn_xp() -> void:
	if not xp:
		return
		
	var xp_instance = xp.instantiate()
	xp_instance.global_position = global_position
	get_parent().add_child(xp_instance)
	
	# Pick a random direction and distance to throw the XP
	var random_direction := Vector2.RIGHT.rotated(randf_range(0, 2 * PI))
	var random_distance := randf_range(20.0, 50.0)
	var target_position := global_position + (random_direction * random_distance)
	
	# FIX: Create the tween bound to the XP instance so it survives the enemy's death
	var tween := xp_instance.create_tween().set_parallel(true)
	tween.tween_property(xp_instance, "global_position", target_position, 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


@export var heart: PackedScene


func spawn_heart() -> void:
	if not heart:
		return

	var heart_instance = heart.instantiate()
	heart_instance.global_position = global_position
	get_parent().add_child(heart_instance)

	var random_direction := Vector2.RIGHT.rotated(randf_range(0, 2 * PI))
	var random_distance := randf_range(20.0, 50.0)
	var target_position := global_position + (random_direction * random_distance)

	var tween := heart_instance.create_tween().set_parallel(true)
	tween.tween_property(heart_instance, "global_position", target_position, 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


signal health_change(health: int)

func add_health(amount: int) -> void:
	health += amount

	health_change.emit(health)
