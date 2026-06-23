class_name ExperienceComponent
extends Node

signal experience_changed(current: int, required: int, level: int)
signal leveled_up(new_level: int)

@export var base_required_experience := 10
@export var growth_multiplier := 1.25

var level := 1
var current_experience := 0
var required_experience := 10

func _ready() -> void:
	required_experience = base_required_experience
	
func setup() -> void:
	level = 1
	current_experience = 0
	required_experience = base_required_experience
	experience_changed.emit(current_experience, required_experience, level)
	
func add_experience(amount: int) -> void:
	if amount <= 0:
		return
	
	current_experience += amount
	
	while current_experience >= required_experience:
		current_experience -= required_experience
		_level_up()
	
	experience_changed.emit(current_experience, required_experience, level)
	
func _level_up() -> void:
	level += 1
	required_experience = int(ceil(required_experience * growth_multiplier))
	leveled_up.emit(level)
