class_name CharacterData
extends Resource

@export var id: StringName
@export var display_name: String
@export_multiline var description: String

@export_group("Visuals")
@export var portrait: Texture2D

@export_group("Statistics")
@export var max_health: float = 100.0
@export var movement_speed: float = 200.0
@export var base_damage: float = 20.0

@export_group("Equipment")
@export var starting_weapon: WeaponData
