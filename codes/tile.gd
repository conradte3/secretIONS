extends Node2D
class_name RuneTile

static var frame_count := 0


@onready var rune := $Rune as Sprite2D

func _ready() -> void:
	rune.frame = frame_count
	frame_count = (frame_count + 1) % 26
	#set_highlight(false)
	#$Rune.frame = randi_range(0, 25)

func set_highlight(is_bright: bool) -> void:
	if is_bright:
		rune.self_modulate = Color.WHITE
	else:
		rune.self_modulate = Color.DARK_SLATE_BLUE

func press() -> String:
	var tw = create_tween()
	tw.tween_property($BasePressed, "visible", false, 1.0).from(true)
	return get_letter()

const ASCII_A = 65
func get_letter() -> String:
	return char(ASCII_A + rune.frame)
