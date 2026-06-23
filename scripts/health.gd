class_name HealthComponent
extends Node

signal health_changed(current: float, maximum: float)
signal died

var maximum_health := 0.0
var current_health := 0.0
var is_dead := false

func setup(max_health: float) -> void:
	maximum_health = max_health
	current_health = max_health
	is_dead = false
	health_changed.emit(current_health, maximum_health)
	
func take_damage(amount: float) -> void:
	if is_dead or amount <= 0.0:
		return
	current_health = maxf(current_health - amount, 0.0)
	health_changed.emit(current_health, maximum_health)
	
	if is_zero_approx(current_health):
		is_dead = true
		died.emit()
