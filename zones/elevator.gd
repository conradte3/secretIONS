class_name Elevator extends ZoneChanger

@export var tower_id : int

@onready var collider := $CollisionShape2D as CollisionShape2D

func _ready() -> void:
	super._ready()
	collider.disabled = true

func enter_sequence(code: String) -> bool:
	var floor = Scenes.get_from_code(code, tower_id)
	if floor == null:
		return false

	loaded_destination = floor
	collider.disabled = false
	return true
