extends Node2D

const MAIN_MENU_SCENE := "res://scenes/ui/main_menu.tscn"

@export var player_scene: PackedScene
@export var debug_character: CharacterData
@export var game_over_scene: PackedScene

@onready var entities: Node2D = $Entities
@onready var attacks: Node2D = %Attacks
@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var ground: TileMapLayer = $Ground
@onready var enemy_spawner: EnemySpawner = $EnemySpawner
@onready var ui: CanvasLayer = $UI
@onready var hud: GameHUD = $GameHUD
@onready var pause_menu: PauseMenu = $UI/PauseMenu

var player: Player
var enemies_killed := 0
var survived_time := 0.0
var game_finished := false
var is_paused_by_menu := false

func _ready() -> void:
	get_tree().paused = false
	
	pause_menu.resume_requested.connect(_resume_game)
	pause_menu.exit_requested.connect(_exit_to_main_menu)
	
	_spawn_player()
	enemy_spawner.enemy_spawned.connect(_on_enemy_spawned)

func _process(delta: float) -> void:
	if game_finished:
		return
	survived_time += delta
	hud.set_time(survived_time)

func _spawn_player() -> void:
	var character := GameSession.selected_character
	
	if character == null:
		character = debug_character
	
	if character == null:
		push_error("No hay ningún personaje seleccionado!")
	
	player = player_scene.instantiate() as Player
	
	entities.add_child(player)
	player.global_position = player_spawn.global_position
	player.setup(character, attacks)
	player.died.connect(_on_player_died)
	
	hud.setup(player)
	hud.set_kills(enemies_killed)
	hud.set_time(survived_time)
	
	enemy_spawner.setup(
		player.player_camera,
		entities,
		ground
	)

func _on_enemy_spawned(enemy: Enemy) -> void:
	enemy.killed.connect(_on_enemy_killed)
	
func _on_enemy_killed(_enemy: Enemy) -> void:
	enemies_killed += 1
	hud.set_kills(enemies_killed)
	
	if is_instance_valid(player) and _enemy.data != null:
		player.add_experience(_enemy.data.experience_reward)
	
func _on_player_died() -> void:
	if game_finished:
		return
	
	game_finished = true
	is_paused_by_menu = false
	pause_menu.close()
	
	get_tree().paused = true
	
	var game_over := game_over_scene.instantiate() as GameOverScreen
	ui.add_child(game_over)
	game_over.setup(enemies_killed, survived_time)

func _unhandled_input(event: InputEvent) -> void:
	if game_finished:
		return
	
	if event.is_action_pressed("ui_cancel"):
		if is_paused_by_menu:
			_resume_game()
		else:
			_pause_game()

func _pause_game() -> void:
	is_paused_by_menu = true
	get_tree().paused = true
	pause_menu.open()
	
func _resume_game() -> void:
	is_paused_by_menu = false
	get_tree().paused = false
	pause_menu.close()
	
func _exit_to_main_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)
