class_name Enemy
extends CharacterBody2D

@export var data: EnemyData

@onready var sprite: Sprite2D = $Sprite2D
@onready var health: HealthComponent = $HealthComponent
@onready var health_bar: HealthBar = $HealthBar
@onready var contact_damage: ContactDamageArea = $ContactDamageArea

var target: Node2D

signal killed(enemy: Enemy)

func _ready() -> void:
	add_to_group("enemies")
	if data == null:
		push_error("Enemy necesita un EnemyData")
		set_physics_process(false)
		return
	sprite.texture = data.texture
	#sprite.modulate = Color(1.0, 0.4, 0.4)
	
	contact_damage.setup(data.contact_damage)
	health.setup(data.max_health)
	health_bar.setup(health)
	health.died.connect(_on_died)
	
func _physics_process(delta: float) -> void:
	if not is_instance_valid(target):
		target = get_tree().get_first_node_in_group("player") as Node2D
		
	if target == null:
		velocity = Vector2.ZERO
	
	var direction := global_position.direction_to(target.global_position)
	velocity = direction * data.movement_speed
	
	move_and_slide()
	
func take_damage(amount: float) -> void:
	health.take_damage(amount)
	
func _on_died() -> void:
	killed.emit(self)
	queue_free()
