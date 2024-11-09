class_name Bow extends Node2D

signal shot_released(charged_time: float)

var charged_time := 0.0
var charging := false

var pull := charged_time

var min_charge_time := 0.5

var mouse_vec := Vector2.RIGHT

func _process(delta: float) -> void:
	mouse_vec = global_position.direction_to(get_global_mouse_position())
	if Input.is_action_pressed("act"):
		charged_time += delta
		pull = charged_time
	elif charged_time > 0.0:
		if charged_time < min_charge_time:
			charged_time += delta
		else:
			end_charge()

	queue_redraw()

func end_charge() -> void:
	shot_released.emit(charged_time)

	charging = false
	charged_time = 0.0
	var tw = create_tween()
	tw.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tw.tween_property(self, "pull", 0.0, 0.3)
	

func _draw() -> void:
	# Bow
	var scaled_pull := minf(pull * 32.0, 32.0)

	var base_radius = 64.0
	var base_angle = TAU / 8.0
	var string_length = base_radius * sin(base_angle)
	var arc_length = base_radius * base_angle

	var radius = base_radius - scaled_pull
	var angle = arc_length / radius

	var center = mouse_vec * scaled_pull

	draw_arc(
		center,
		radius,
		mouse_vec.angle() - angle,
		mouse_vec.angle() + angle,
		12,
		Color.WHITE,
		1.0,
		true
	)

	var vec = mouse_vec * radius
	var top = vec.rotated(-angle)
	var down_length = radius * sin(angle)
	var string_angle = acos(down_length / string_length)

	var down = mouse_vec.orthogonal() * -1
	var middle = (down * string_length).rotated(string_angle)
	top += center
	draw_line(top, top + middle, Color.GRAY, 1.0, true)
	var bot = vec.rotated(angle)
	bot += center
	middle = (down * string_length).rotated(-string_angle)
	draw_line(bot, bot - middle, Color.GRAY, 1.0, true)


	draw_line(Vector2.ZERO, mouse_vec * 20.0, Color.GREEN)
