class_name LifetimeComponent
extends Node

signal expired

var remaining_time := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)

func setup(duration: float) -> void:
	remaining_time = duration
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	remaining_time -= delta
	
	if remaining_time <= 0.0:
		set_process(false)
		expired.emit()
