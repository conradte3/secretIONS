class_name ZoneChanger extends Area2D

@export var destination : PackedScene

func _ready() -> void:
	collision_layer = 0
	collision_mask = 0
	set_collision_mask_value(2, true)

	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	var info = ZoneChangeInfo.new()

	info.changer = self
	info.from = owner
	info.to = destination

	Events.changer_entered.emit.call_deferred(info)
