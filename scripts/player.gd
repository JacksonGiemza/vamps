extends CharacterBody2D

const SPEED = 300.0

# 1. Preload your separate sword scene file
const SWORD_SCENE = preload("res://scenes/sword.tscn")

# 2. Reference the nodes inside the player
@onready var weapon_slot: Node2D = $WeaponSlot
var current_weapon: Node2D = null


func _ready() -> void:
	# 3. Equip the sword as soon as the game starts
	add_to_group("Player") 
	equip_weapon(SWORD_SCENE)


signal health_change(health: int)
var health: int = 100
var can_take_damage := true
var damage_cooldown := 0.5
var damage_timer := 0.0

func _physics_process(delta: float) -> void:
	if not can_take_damage:
		damage_timer -= delta

		if damage_timer <= 0:
			can_take_damage = true


	var direction = Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
		"ui_down"
	)

	if direction != Vector2.ZERO:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()


	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		if collider and collider.is_in_group("enemy") and can_take_damage:
			take_damage(10)
			
	if Input.is_action_just_pressed("ui_accept") and current_weapon != null:
		if current_weapon.has_method("attack"):
			current_weapon.attack()


func take_damage(amount: int) -> void:
	health -= amount
	health = max(health, 0)

	health_change.emit(health)

	can_take_damage = false
	damage_timer = damage_cooldown

	if health == 0:
		die()

@export var death_screen: CanvasLayer

func die() -> void:
	death_screen.show_death_screen()

func add_health(amount: int):
	health += amount
	health = min(health, 100)
	health_change.emit(health)


signal xp_changed(xp: int)
var xp: int = 0

signal level_changed(level: int)
var level: int = 1
var max_xp: int = 10

func add_xp(amount: int):
	xp += amount
	xp = min(xp, max_xp)
	
	if xp == max_xp:
		add_level()
		xp = 0
		max_xp *= 2

	xp_changed.emit(xp)

func add_level():
	level += 1
	level_changed.emit(level)


func equip_weapon(weapon_scene: PackedScene) -> void:
	# Clear out any old weapon first
	if current_weapon != null:
		current_weapon.queue_free()
	
	# Create the new weapon instance and attach it to the slot
	current_weapon = weapon_scene.instantiate()
	weapon_slot.add_child(current_weapon)
