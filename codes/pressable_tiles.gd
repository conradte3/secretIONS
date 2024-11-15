extends TileMapLayer

@export var display_start : Vector2i
@export var elevator : Node2D

var scene_coords: Dictionary[Vector2i, Node] = {}


var current_sequence := ""
var active_displays := [] as Array[DisplayTile]

var locked_in = false

func _ready() -> void:
	Events.tile_press_attempted.connect(handle_press_attempt)

func handle_press_attempt(pos: Vector2) -> void:
	if locked_in:
		return

	var tile := get_press_tile_at_position(pos)
	if not tile:
		return

	var new_char = tile.press()

	var display_coords = display_start + Vector2i(current_sequence.length(), 0)
	var display = get_cell_scene(display_coords)
	if display is DisplayTile:
		display.set_char(new_char)
		active_displays.append(display)

	current_sequence += new_char
	try_finish_sequence()

func try_finish_sequence() -> void:
	if current_sequence.length() != 4:
		return

	if elevator.enter_sequence(current_sequence):
		locked_in = true
		return

	locked_in = true
	await get_tree().create_timer(1.0).timeout
	for disp in active_displays:
		disp.set_char("")
	active_displays.clear()
	current_sequence = ""
	locked_in = false

func get_press_tile_at_position(global_pos: Vector2) -> RuneTile:
	var coords = local_to_map(to_local(global_pos))
	var node = get_cell_scene(coords)

	if node is RuneTile:
		return node
	return null


func get_cell_scene(coords: Vector2i) -> Node:
	return scene_coords.get(coords, null)

func _enter_tree() -> void:
	child_entered_tree.connect(_register_child)
	child_exiting_tree.connect(_unregister_child)

func _register_child(child: Node):
	await child.ready
	var coords = local_to_map(to_local(child.global_position))
	scene_coords[coords] = child
	child.set_meta("tile_coords", coords)

func _unregister_child(child: Node):
	scene_coords.erase(child.get_meta("tile_coords"))
