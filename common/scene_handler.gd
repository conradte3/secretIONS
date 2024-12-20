extends Node

@export var floor_codes : Dictionary[String, PackedScene]

var _root : Node

var _active_change : ZoneChangeInfo

func _ready() -> void:
	_root = get_tree().root

func get_from_code(floor_code: String, tower_id: int) -> PackedScene:
	var full_code = "{1}-{0}".format([floor_code, tower_id])
	return floor_codes.get(full_code, null)

func change_zone(info: ZoneChangeInfo) -> void:
	if _active_change == null:
		_active_change = info
		_unload.call_deferred()

func _unload() -> void:
	_active_change.from.tree_exited.connect(_on_unload)
	_active_change.from.queue_free()

func _on_unload() -> void:
	var inst = _active_change.to.instantiate()
	inst.ready.connect(_on_load.bind(inst))
	_root.add_child(inst)

func _on_load(inst: Node) -> void:
	if _active_change.has_position:
		var player = inst.get_tree().get_first_node_in_group("player")
		if player:
			player.global_position = _active_change.from_position
	
	_active_change = null
