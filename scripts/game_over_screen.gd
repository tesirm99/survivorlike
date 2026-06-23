class_name GameOverScreen
extends Control

const CHARACTER_SELECTION_SCREEN := "res://scenes/ui/character_selection.tscn"

@onready var kills_label: Label = %KillsLabel
@onready var time_label: Label = %TimeLabel
@onready var back_button: Button = %BackButton

func _ready() -> void:
	back_button.pressed.connect(_on_back_button_pressed)

func setup(kills: int, survived_time: float) -> void:
	kills_label.text = "Enemigos eliminados: %d" % kills
	time_label.text = "Tiempo sobrevivido: %s" % _format_time(survived_time)

func _format_time(seconds: float) -> String:
	var total_seconds := int(seconds)
	var minutes := total_seconds / 60
	var remaining_seconds := total_seconds % 60
	return "%02d:%02d" % [minutes, remaining_seconds]

func _on_back_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(CHARACTER_SELECTION_SCREEN)
