class_name EnemySpawner
extends Node

@export var enemy_scene: PackedScene
@export var enemy_data: EnemyData
@export_range(0.1, 30.0) var spawn_interval := 2.0
@export_range(1, 1000) var maximum_enemies := 50
@export var spawn_margin := 100.0
@export var spawn_band_width := 150.0

@onready var spawn_timer: Timer = $SpawnTimer

signal enemy_spawned(enemy: Enemy)

var camera: Camera2D
var enemy_parent: Node2D
var ground: TileMapLayer

func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	
func setup(
	player_camera: Camera2D,
	entities: Node2D,
	ground_layer: TileMapLayer
) -> void:
	camera = player_camera
	enemy_parent = entities
	ground = ground_layer
	
	spawn_timer.wait_time = spawn_interval
	spawn_timer.start()
	
func _on_spawn_timer_timeout() -> void:
	if get_tree().get_nodes_in_group("enemies").size() >= maximum_enemies:
		return
	
	var spawn_position := _find_spawn_position()
	
	if spawn_position == Vector2.INF:
		return
	
	var enemy := enemy_scene.instantiate() as Enemy
	enemy.data = enemy_data
	enemy_parent.add_child(enemy)
	enemy.global_position = spawn_position
	enemy_spawned.emit(enemy)

func _find_spawn_position() -> Vector2:
	var viewport_size := camera.get_viewport_rect().size
	var visible_half_size := viewport_size * 0.5 / camera.zoom
	var minimum_distance := visible_half_size.length() + spawn_margin
	var maximum_distance := minimum_distance + spawn_band_width
	var camera_center := camera.get_screen_center_position()
	
	for attempt in 12:
		var angle := randf_range(0.0, TAU)
		var distance := randf_range(minimum_distance, maximum_distance)
		var candidate := camera_center + Vector2.RIGHT.rotated(angle) * distance
		
		var local_position := ground.to_local(candidate)
		var cell := ground.local_to_map(local_position)
		
		if ground.get_cell_source_id(cell) != -1:
			return candidate
	return Vector2.INF

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
