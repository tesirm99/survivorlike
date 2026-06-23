class_name GameHUD
extends CanvasLayer

@onready var health_bar: ProgressBar = %TopHealthBar
@onready var time_label: Label = %TimeLabel
@onready var kills_label: Label = %KillsLabel
@onready var level_label: Label = %LevelLabel
@onready var experience_bar: ProgressBar = %ExperienceBar

func setup(player: Player) -> void:
	player.health_changed.connect(_on_player_health_changed)
	player.experience_changed.connect(_on_player_experience_changed)

func set_kills(amount: int) -> void:
	kills_label.text = "Enemigos eliminados: %d" % amount

func set_time(seconds: float) -> void:
	time_label.text = "Tiempo: %s" % _format_time(seconds)

func _on_player_health_changed(current: float, maximum: float) -> void:
	health_bar.max_value = maximum
	health_bar.value = current
	
func _on_player_experience_changed(current: int, required: int, level: int) -> void:
	experience_bar.max_value = required
	experience_bar.value = current
	level_label.text = "Nivel %d" % level

func _format_time(seconds: float) -> String:
	var total_seconds := int(seconds)
	var minutes := total_seconds / 60
	var remaining_seconds := total_seconds % 60

	return "%02d:%02d" % [minutes, remaining_seconds]
