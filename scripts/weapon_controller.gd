class_name WeaponController
extends Node

@export var attack_scene: PackedScene

@onready var cooldown_timer: Timer = $CooldownTimer

var weapon: WeaponData
var base_damage := 0.0
var attack_parent: Node
var damage_mod := 1.0
var attack_speed_mod := 1.0

func setup(
	new_weapon: WeaponData,
	new_base_damage: float,
	new_attack_parent: Node
) -> void:
	weapon = new_weapon
	base_damage = new_base_damage
	attack_parent = new_attack_parent
	cooldown_timer.wait_time = weapon.cooldown / attack_speed_mod

func attack(origin: Vector2, direction: Vector2) -> void:
	if weapon == null or not cooldown_timer.is_stopped():
		return
	
	var instance := attack_scene.instantiate() as Attack
	attack_parent.add_child(instance)
	
	instance.initialize(
		weapon.attack_data,
		origin,
		direction,
		base_damage * weapon.damage_multiplier * damage_mod
	)
	print("PLAYER ATACA CON %d DAÑO" % (base_damage * weapon.damage_multiplier * damage_mod))
	cooldown_timer.start()

func set_modifiers(new_damage_mod: float, new_attack_speed_mod: float) -> void:
	damage_mod += new_damage_mod
	attack_speed_mod += new_attack_speed_mod
	
	if weapon != null:
		cooldown_timer.wait_time = weapon.cooldown / attack_speed_mod
