class_name EnemyData
extends Resource

@export var id: StringName
@export var display_name: String
@export var texture: Texture2D

@export_group("Statistics")
@export var max_health := 50.0
@export var movement_speed := 80.0
@export var contact_damage := 10.0
@export var experience_reward := 5
