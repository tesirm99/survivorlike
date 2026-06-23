class_name HitboxComponent
extends Node

signal target_limit_reached

var damage := 0.0
var max_targets := 1
var targets_hit: Dictionary[int, bool] = {}

func _ready() -> void:
	var area := get_parent() as Area2D
	area.body_entered.connect(_on_body_entered)

func setup(new_damage: float, new_max_targets: int) -> void:
	damage = new_damage
	max_targets = new_max_targets
	targets_hit.clear()

func _on_body_entered(body: Node) -> void:
	if not body.has_method("take_damage"):
		return
	
	var target_id := body.get_instance_id()
	
	if targets_hit.has(target_id):
		return
		
	targets_hit[target_id] = true
	body.take_damage(damage)
	
	if max_targets > 0 and targets_hit.size() >= max_targets:
		target_limit_reached.emit()
