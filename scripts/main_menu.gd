extends Control

const CHARACTER_SELECTION_SCENE := "res://scenes/ui/character_selection.tscn"

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file(CHARACTER_SELECTION_SCENE)

func _on_exit_button_pressed() -> void:
	get_tree().quit()
