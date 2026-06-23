class_name Player
extends CharacterBody2D

signal died
signal health_changed(current:float, maximum:float)
signal experience_changed(current: int, required: int, level: int)
signal leveled_up(new_level: int)

@onready var sprite: Sprite2D = $Sprite2D
@onready var weapon_controller: Node = $WeaponController
@onready var health: HealthComponent = $HealthComponent
@onready var health_bar: HealthBar = $HealthBar
@onready var experience: ExperienceComponent = $ExperienceComponent
@onready var player_camera: Camera2D = $Camera2D
@onready var invulnerability_timer: Timer = $InvulnerabilityTimer
var data: CharacterData

func _ready() -> void:
	add_to_group("player")
	health.health_changed.connect(_on_health_changed)
	health.died.connect(_on_died)
	
	experience.experience_changed.connect(_on_experience_changed)
	experience.leveled_up.connect(_on_leveled_up)

func setup(character: CharacterData, attack_parent: Node) -> void:
	data = character
	sprite.texture = character.portrait
	
	health.setup(data.max_health)
	health_bar.setup(health)
	
	experience.setup()
	
	weapon_controller.setup(
		data.starting_weapon,
		data.base_damage,
		attack_parent
	)
	
func add_experience(amount: int) -> void:
	experience.add_experience(amount)

func _physics_process(delta: float) -> void:
	if data == null:
		velocity = Vector2.ZERO
		return
		
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = direction * data.movement_speed
	move_and_slide()
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		var direction := global_position.direction_to(get_global_mouse_position())
		weapon_controller.attack(global_position, direction)

func take_damage(amount: float) -> void:
	if not invulnerability_timer.is_stopped():
		return
	
	health.take_damage(amount)
	invulnerability_timer.start()
	_flash_after_damage()

func _flash_after_damage() -> void:
	var tween := create_tween()
	tween.tween_property(sprite, "modulate", Color.RED, 0.05)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.15)

func _on_health_changed(current: float, maximum: float) -> void:
	health_changed.emit(current, maximum)
	
func _on_experience_changed(current: int, required: int, level: int) -> void:
	experience_changed.emit(current, required, level)
	
func _on_leveled_up(new_level: int) -> void:
	leveled_up.emit(new_level)

func _on_died() -> void:
	set_physics_process(false)
	died.emit()
