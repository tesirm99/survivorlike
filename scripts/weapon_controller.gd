class_name WeaponController
extends Node

@export var attack_scene: PackedScene

@onready var cooldown_timer: Timer = $CooldownTimer

var weapon: WeaponData
var base_damage := 0.0
var attack_parent: Node

func setup(
	new_weapon: WeaponData,
	new_base_damage: float,
	new_attack_parent: Node
) -> void:
	weapon = new_weapon
	base_damage = new_base_damage
	attack_parent = new_attack_parent
	cooldown_timer.wait_time = weapon.cooldown

func attack(origin: Vector2, direction: Vector2) -> void:
	if weapon == null or not cooldown_timer.is_stopped():
		return
	
	var instance := attack_scene.instantiate() as Attack
	attack_parent.add_child(instance)
	
	instance.initialize(
		weapon.attack_data,
		origin,
		direction,
		base_damage * weapon.damage_multiplier
	)
	
	cooldown_timer.start()
