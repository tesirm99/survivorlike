extends Control

const MAIN_MENU_SCENE := "res://scenes/ui/main_menu.tscn"
const GAME_SCENE := "res://scenes/game.tscn"

@export var available_characters: Array[CharacterData]

@onready var buttons_container: VBoxContainer = %CharacterButtonsContainer
@onready var character_sprite: TextureRect = %CharacterSprite
@onready var character_name: Label = %CharacterName
@onready var character_description: Label = %CharacterDescription
@onready var health_label: Label = %HealthLabel
@onready var speed_label: Label = %SpeedLabel
@onready var damage_label: Label = %DamageLabel
@onready var weapon_label: Label = %WeaponLabel
@onready var play_button: Button = %PlayButton

var selected_character: CharacterData
var character_button_group := ButtonGroup.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_create_character_buttons()
	if not available_characters.is_empty():
		_select_character(available_characters[0])

func _create_character_buttons() -> void:
	for character in available_characters:
		var button := Button.new()
		button.text = character.display_name
		button.icon = character.portrait
		button.expand_icon = true
		button.custom_minimum_size = Vector2(0, 80)
		button.toggle_mode = true
		button.button_group = character_button_group
		button.pressed.connect(_select_character.bind(character))
		
		buttons_container.add_child(button)
		
	if buttons_container.get_child_count() > 0:
		var first_button := buttons_container.get_child(0) as Button
		first_button.button_pressed = true
		first_button.grab_focus()

func _select_character(character: CharacterData) -> void:
	selected_character = character
	character_sprite.texture = character.portrait
	character_name.text = character.display_name
	character_description.text = character.description
	
	health_label.text = "Vida: %d" % int(character.max_health)
	speed_label.text = "Velocidad: %d" % int(character.movement_speed)
	damage_label.text = "Daño: %d" % int(character.base_damage)
	
	if character.starting_weapon:
		weapon_label.text = "%s - %s" % [
			character.starting_weapon.display_name,
			character.starting_weapon.description
		]
	else:
		weapon_label.text = "Sin arma inicial"
	
	play_button.disabled = false

	
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)
	
func _on_play_button_pressed() -> void:
	if selected_character == null:
		return
	GameSession.selected_character = selected_character
	get_tree().change_scene_to_file(GAME_SCENE)
