class_name ContactDamageArea
extends Area2D

@onready var damage_timer: Timer = $DamageTimer

var damage := 0.0
var targets: Array[Node] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	damage_timer.timeout.connect(_damage_targets)
	
func setup(new_damage: float) -> void:
	damage = new_damage
	
func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage") and not targets.has(body):
		targets.append(body)
		body.take_damage(damage)
	if damage_timer.is_stopped():
		damage_timer.start()

func _on_body_exited(body: Node) -> void:
	targets.erase(body)
	if targets.is_empty():
		damage_timer.stop()
		
func _damage_targets() -> void:
	for target in targets.duplicate():
		if not is_instance_valid(target):
			targets.erase(target)
		elif target.has_method("take_damage"):
			target.take_damage(damage)
