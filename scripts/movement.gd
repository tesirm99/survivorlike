class_name MovementComponent
extends Node

var direction := Vector2.ZERO
var speed := 0.0

func _ready() -> void:
	set_physics_process(false)

func setup(new_direction: Vector2, new_speed: float) -> void:
	direction = new_direction.normalized()
	speed = new_speed
	set_physics_process(not is_zero_approx(speed))

func _physics_process(delta: float) -> void:
	var attack := get_parent() as Area2D
	attack.global_position += direction * speed * delta
