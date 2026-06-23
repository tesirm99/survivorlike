class_name WeaponData
extends Resource

@export var id: StringName
@export var display_name: String
@export_multiline var description: String
@export var icon: Texture2D
@export var attack_data: AttackData
@export_range(0.05, 10.0) var cooldown := 0.5
@export var damage_multiplier := 1.0
