class_name ZoneChanger extends Area2D

@export_file("*.tscn") var destination : String
@export var keep_position := true
@export var is_fall_zone := false
@export var change_on_exit := false

var loaded_destination : PackedScene

func _ready() -> void:
	collision_layer = 0
	collision_mask = 0
	set_collision_mask_value(2, true)
	if is_fall_zone:
		set_collision_mask_value(3, true)

	if change_on_exit:
		body_exited.connect(_on_body_entered)
	else:
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if not destination and not loaded_destination:
			printerr("No destination set for ", self)
			return

		var info = ZoneChangeInfo.new()

		info.changer = self
		info.from = owner
		if loaded_destination:
			info.to = loaded_destination
		else:
			info.to = load(destination)
		if keep_position:
			info.has_position = true
			info.from_position = body.global_position

		Scenes.change_zone(info)
	elif is_fall_zone:
		body.queue_free()
