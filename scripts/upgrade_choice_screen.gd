class_name UpgradeChoiceScreen
extends Control

signal upgrade_selected(upgrade: UpgradeData)

@onready var buttons: Array[Button] = [
	%ChoiceButton1,
	%ChoiceButton2,
	%ChoiceButton3
]

var current_upgrades: Array[UpgradeData] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in buttons.size():
		buttons[i].pressed.connect(_on_button_pressed.bind(i))

func open(upgrades: Array[UpgradeData]) -> void:
	current_upgrades = upgrades
	visible = true
	for i in buttons.size():
		var upgrade := current_upgrades[i]
		buttons[i].text = "%s\n%s" % [
			upgrade.display_name,
			upgrade.value
		]
	buttons[0].grab_focus()
	
func close() -> void:
	visible = false
	current_upgrades.clear()

func _on_button_pressed(index: int) -> void:
	if index < 0 or index >= current_upgrades.size():
		return
	upgrade_selected.emit(current_upgrades[index])
