class_name HitInfo extends RefCounted

var from_box : Hitbox
var to_box : Hurtbox

var from_pos : Vector2
var to_pos : Vector2
var direction : Vector2

func _init(from: Hitbox, to: Hurtbox) -> void:
	from_box = from
	to_box = to
	from_pos = from.global_position
	to_pos = to.global_position

	direction = from.direction
	if not direction:
		direction = from_pos.direction_to(to_pos)
