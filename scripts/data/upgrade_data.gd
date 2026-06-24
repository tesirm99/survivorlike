class_name UpgradeData
extends Resource

enum UpgradeType {
	MAX_HEALTH,
	DAMAGE,
	ATTACK_SPEED
}

@export var id: StringName
@export var display_name: String
@export var icon: Texture2D

@export var type: UpgradeType
@export var value := 0.0
