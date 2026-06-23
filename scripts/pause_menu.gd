class_name PauseMenu
extends Control

signal resume_requested
signal exit_requested

@onready var continue_button: Button = %ContinueButton
@onready var exit_button: Button = %ExitButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	continue_button.pressed.connect(_on_continue_pressed)
	exit_button.pressed.connect(_on_exit_pressed)

func open() -> void:
	visible = true
	continue_button.grab_focus()

func close() -> void:
	visible = false

func _on_continue_pressed() -> void:
	resume_requested.emit()
	
func _on_exit_pressed() -> void:
	exit_requested.emit()
