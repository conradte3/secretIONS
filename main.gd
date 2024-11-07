extends Node

func _ready() -> void:
	Events.changer_entered.connect(change_zone)

func change_zone(info: ZoneChangeInfo) -> void:
	info.from.queue_free()
	var inst = info.to.instantiate()
	add_child(inst)
