class_name DisplayTile extends Node2D

var current_display: String

@onready var display_rune := $Rune as Sprite2D

func set_char(new_char: String) -> void:
	if new_char.length() > 1:
		printerr("Setting invalid char %s for display tile", char)
		return

	if new_char.length() == 0:
		display_rune.visible = false
	else:
		display_rune.visible = true
		display_rune.frame = new_char.to_ascii_buffer()[0] - 65
