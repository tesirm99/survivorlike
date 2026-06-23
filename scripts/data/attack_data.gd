class_name AttackData
extends Resource

@export_group("Visuals")
@export var texture: Texture2D
@export var collision_shape: Shape2D
@export var visual_scale := Vector2.ONE

@export_group("Movement")
@export var speed := 500.0
@export var spawn_distance := 20.0

@export_group("Lifetime")
@export_range(0.01, 10.0) var lifetime := 1.0

@export_group("Impact")
@export_range(0, 100) var max_targets := 1
