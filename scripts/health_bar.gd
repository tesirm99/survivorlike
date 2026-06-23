class_name HealthBar
extends Control

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var value_label: Label = $ValueLabel

var health_component: HealthComponent

func setup(component: HealthComponent) -> void:
	health_component = component
	if not health_component.health_changed.is_connected(_on_health_changed):
		health_component.health_changed.connect(_on_health_changed)
		
	_update_bar(
		health_component.current_health,
		health_component.maximum_health
	)
func _on_health_changed(current: float, maximum: float):
	_update_bar(current, maximum)

func _update_bar(current_health: float, max_health: float):
	progress_bar.max_value = max_health
	progress_bar.value = current_health
	
	value_label.text = "%d / %d" % [
		ceili(current_health),
		ceili(max_health)
	]
