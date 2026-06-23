class_name Attack
extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var movement: MovementComponent = $MovementComponent
@onready var hitbox: HitboxComponent = $HitboxComponent
@onready var lifetime: LifetimeComponent = $LifetimeComponent

func _ready() -> void:
	lifetime.expired.connect(queue_free)
	hitbox.target_limit_reached.connect(queue_free)

func initialize(
	data: AttackData,
	origin: Vector2,
	direction: Vector2,
	damage: float
) -> void:
	var normalized_direction := direction.normalized()
	
	global_position = origin + normalized_direction * data.spawn_distance
	rotation = normalized_direction.angle()
	
	sprite.texture = data.texture
	sprite.scale = data.visual_scale
	collision.shape = data.collision_shape.duplicate()
	
	movement.setup(normalized_direction, data.speed)
	lifetime.setup(data.lifetime)
	hitbox.setup(damage, data.max_targets)
