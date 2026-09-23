extends CanvasLayer

@export var player: CharacterBody2D

@onready var speed_button: Button = $Panel/VBoxContainer/SpeedButton
@onready var health_button: Button = $Panel/VBoxContainer/HealthButton
@onready var damage_button: Button = $Panel/VBoxContainer/DamageButton


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	
	player.level_changed.connect(_on_player_level_changed)
	
	speed_button.pressed.connect(_upgrade_speed)
	health_button.pressed.connect(_upgrade_max_health)
	damage_button.pressed.connect(_upgrade_sword)


func _on_player_level_changed(_level: int) -> void:
	get_tree().paused = true
	visible = true
	
	speed_button.grab_focus()


func _upgrade_speed() -> void:
	print("SPEED BUTTON PRESSED")
	player.speed *= 1.10
	close()


func _upgrade_max_health() -> void:
	print("HEALTH BUTTON PRESSED")
	
	player.max_health += 20
	player.health += 20
	player.health_change.emit(player.health)
	
	close()


func _upgrade_sword() -> void:
	print("DAMAGE BUTTON PRESSED")
	
	player.sword.upgrade_damage(1)
	
	close()


func close() -> void:
	visible = false
	get_tree().paused = false
