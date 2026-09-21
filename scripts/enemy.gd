extends CharacterBody2D


const SPEED = 200.0
@export var player: CharacterBody2D

func _ready() -> void:
	add_to_group("enemy") 


func _physics_process(_delta: float) -> void:
	if player:
		var direction: Vector2 = (player.global_position - global_position).normalized()
		velocity = direction * SPEED
		
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()
	
	
# Allows you to drag your XP.tscn file into the Inspector
@export var xp: PackedScene
@export var min_xp_drops: int = 3
@export var max_xp_drops: int = 6

signal died

func die() -> void:
	var drop_count := randi_range(min_xp_drops, max_xp_drops)
	for i in range(drop_count):
		spawn_xp()
	
	var heart_spawn_chance = 0.10
	if randf() < heart_spawn_chance:
		spawn_heart()
	
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
