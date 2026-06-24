class_name WeaponController
extends Node

@export var attack_scene: PackedScene
@export var acquisition_range := 0.0

@onready var cooldown_timer: Timer = $CooldownTimer

var weapon: WeaponData
var base_damage := 0.0
var attack_parent: Node

var damage_mod := 1.0
var attack_speed_mod := 1.0

func _ready() -> void:
	set_physics_process(false)

func setup(
	new_weapon: WeaponData,
	new_base_damage: float,
	new_attack_parent: Node
) -> void:
	weapon = new_weapon
	base_damage = new_base_damage
	attack_parent = new_attack_parent
	
	_update_cooldown()
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	if weapon == null or not cooldown_timer.is_stopped():
		return
	
	var owner := get_parent() as Node2D
	if owner == null:
		return
		
	var target := _find_nearest_enemy(owner.global_position)
	if target == null:
		return
		
	var direction := owner.global_position.direction_to(target.global_position)
	_attack(owner.global_position, direction)

func _update_cooldown() -> void:
	if weapon == null:
		return
	cooldown_timer.wait_time = weapon.cooldown / attack_speed_mod

func _find_nearest_enemy(origin: Vector2) -> Node2D:
	var enemies := get_tree().get_nodes_in_group("enemies")
	var nearest_enemy: Node2D = null
	var nearest_distance := INF
	var max_distance_squared := acquisition_range * acquisition_range
	
	for enemy in enemies:
		var enemy_node := enemy as Node2D
		
		if enemy_node == null or not is_instance_valid(enemy_node):
			continue
		
		var distance := origin.distance_squared_to(enemy_node.global_position)
		
		if acquisition_range > 0.0 and distance > max_distance_squared:
			continue
		
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_enemy = enemy_node
	
	return nearest_enemy

func _attack(origin: Vector2, direction: Vector2) -> void:
	if direction.is_zero_approx():
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

func set_damage_mod(new_damage_mod: float) -> void:
	damage_mod += new_damage_mod
	print("UPGRADED DAMAGE: DMG %d ATK %d" % [damage_mod, attack_speed_mod])
	
func set_attack_speed_mod(new_attack_speed_mod: float) -> void:
	attack_speed_mod += new_attack_speed_mod
	print("UPGRADED ATK SPEED: DMG %d ATK %d" % [damage_mod, attack_speed_mod])
	if weapon != null:
		cooldown_timer.wait_time = weapon.cooldown / attack_speed_mod

func set_modifiers(new_damage_mod: float, new_attack_speed_mod: float) -> void:
	damage_mod += new_damage_mod
	attack_speed_mod += new_attack_speed_mod
	
	if weapon != null:
		cooldown_timer.wait_time = weapon.cooldown / attack_speed_mod
