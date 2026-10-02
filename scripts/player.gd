extends CharacterBody2D


var speed: float = 100.0

# Weapon scenes
const SWORD_SCENE = preload("res://scenes/sword.tscn")
var sword: Node2D

const STAFF_SCENE = preload("uid://crxcrx5wb6eap")
var staff: Node2D

# Player nodes
@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var weapon_slot: Node2D = $WeaponSlot


# Weapon positioning
var weapon_distance: float = 30.0
var last_direction: Vector2 = Vector2.UP


# Health
signal health_change(health: int)
var max_health: int = 100
var health: int = max_health
var can_take_damage: bool = true
var damage_cooldown: float = 0.5
var damage_timer: float = 0.0

@export var death_screen: CanvasLayer


# XP / Level
signal xp_changed(xp: int)
signal level_changed(level: int)

var xp: int = 0
var level: int = 1
var max_xp: int = 10


func _ready() -> void:
	add_to_group("Player")

	# Player always starts with sword
	#add_weapon(SWORD_SCENE)
	sword = SWORD_SCENE.instantiate()
	weapon_slot.add_child(sword)
	
	#staff = STAFF_SCENE.instantiate()
	#weapon_slot.add_child(staff)
	


func _physics_process(delta: float) -> void:
	handle_damage_cooldown(delta)

	var direction := Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
		"ui_down"
	)

	handle_movement(direction)
	handle_facing(direction)
	position_weapon()
	check_enemy_collisions()


# -------------------------
# Movement
# -------------------------

func handle_movement(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		velocity = direction * speed
		
		if sprite.animation != "running":
			sprite.play("running")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)
		
		if sprite.animation != "idle":
			sprite.play("idle")
			
	move_and_slide()


func handle_facing(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		return

	last_direction = snap_to_cardinal_direction(direction)

	# Flip player sprite left/right
	if direction.x < 0:
		sprite.flip_h = true
	elif direction.x > 0:
		sprite.flip_h = false


func snap_to_cardinal_direction(dir: Vector2) -> Vector2:
	if abs(dir.x) > abs(dir.y):
		return Vector2(sign(dir.x), 0)
	else:
		return Vector2(0, sign(dir.y))


# -------------------------
# Weapon
# -------------------------

func position_weapon() -> void:
	# Put weapon on the side the player is facing
	weapon_slot.position = last_direction * weapon_distance

	# Keep slash perpendicular to attack direction
	if last_direction.x != 0:
		weapon_slot.rotation = PI / 2
	else:
		weapon_slot.rotation = 0

	# Mirror slash when facing left/down
	if last_direction == Vector2.LEFT or last_direction == Vector2.DOWN:
		weapon_slot.scale.y = -1
	else:
		weapon_slot.scale.y = 1


func add_weapon(weapon_scene: PackedScene) -> void:
	var weapon = weapon_scene.instantiate()
	weapon_slot.add_child(weapon)


# -------------------------
# Health / Damage
# -------------------------

func handle_damage_cooldown(delta: float) -> void:
	if not can_take_damage:
		damage_timer -= delta

		if damage_timer <= 0:
			can_take_damage = true


func check_enemy_collisions() -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		if collider and collider.is_in_group("enemy") and can_take_damage:
			take_damage(10)

func take_damage(amount: int) -> void:
	health -= amount
	health = max(health, 0)

	health_change.emit(health)

	can_take_damage = false
	damage_timer = damage_cooldown

	if health == 0:
		die()


func add_health(amount: int) -> void:
	health += amount
	health = min(health, max_health)

	health_change.emit(health)


func die() -> void:
	death_screen.show_death_screen()


# -------------------------
# XP / Level
# -------------------------

func add_xp(amount: int) -> void:
	xp += amount
	xp = min(xp, max_xp)

	if xp == max_xp:
		add_level()
		xp = 0
		max_xp *= 2

	xp_changed.emit(xp)


func add_level() -> void:
	level += 1
	level_changed.emit(level)
