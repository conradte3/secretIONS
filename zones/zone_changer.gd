class_name ZoneChanger extends Area2D

@export_file("*.tscn") var destination : String
@export var is_fall_zone := false

func _ready() -> void:
	collision_layer = 0
	collision_mask = 0
	set_collision_mask_value(2, true)
	if is_fall_zone:
		set_collision_mask_value(3, true)

	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var info = ZoneChangeInfo.new()

		info.changer = self
		info.from = owner
		info.to = load(destination)
		info.from_position = body.global_position

		Events.changer_entered.emit.call_deferred(info)
	elif is_fall_zone:
		body.queue_free()
