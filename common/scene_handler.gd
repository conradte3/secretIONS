extends Node

var root : Node

func _ready() -> void:
	root = get_tree().root

	Events.changer_entered.connect(change_zone)

func change_zone(info: ZoneChangeInfo) -> void:
	info.from.tree_exited.connect(on_unload.bind(info))
	info.from.queue_free()


func on_unload(info: ZoneChangeInfo) -> void:
	var inst = info.to.instantiate()
	inst.ready.connect(on_load.bind(inst, info))
	root.add_child(inst)


func on_load(inst: Node, info: ZoneChangeInfo) -> void:
	var player = inst.get_tree().get_first_node_in_group("player")
	player.global_position = info.from_position
