extends Node2D

@export var jump_progress := 0.0
var start_pos : Vector2
var end_pos : Vector2

var target: Node2D

@onready var anim := $AnimationPlayer as AnimationPlayer


var knock_dir := Vector2.ZERO
var knock_time := 0.0

func _ready() -> void:
	target = get_tree().get_first_node_in_group("player")
	anim.animation_finished.connect(_on_anim_finished)
	
	$Hurtbox.was_hit.connect(_on_hit)

func _on_anim_finished(anim_name: String) -> void:
	if anim_name == "jump":
		jump_progress = 0.0
		start_idle()
	elif anim_name == "idle":
		if target:
			start_jump()
		else:
			start_idle()

func start_idle() -> void:
	anim.play("idle")

func start_jump() -> void:
	anim.play("jump")
	start_pos = global_position
	end_pos = calculate_destination()

func calculate_destination() -> Vector2:
	return global_position + global_position.direction_to(target.global_position) * 300.0

func _process(delta: float) -> void:
	if knock_time > 0.0:
		knock_time -= delta
		if knock_time <= 0.0:
			anim.play()
		else:
			global_position += knock_dir * delta * 200.0
	elif jump_progress > 0.0:
		global_position = start_pos.lerp(end_pos, jump_progress)

var shock_radius := 0.0

func activate_hitbox() -> void:
	var tw = create_tween()
	tw.tween_method(update_shockwave, 0.0, 1.0, 0.3)
	tw.parallel().tween_property($Hitbox/CollisionShape2D, "disabled", true, 0.3).from(false)
	tw.tween_callback(update_shockwave.bind(0.0))

func update_shockwave(progress: float) -> void:
	queue_redraw()
	shock_radius = progress * 240.0

func _draw() -> void:
	if shock_radius > 0.0:
		draw_circle(Vector2.ZERO, shock_radius, Color.WHITE, false, 4.0)

func _on_hit(info: HitInfo) -> void:
	if anim.current_animation == "idle":
		anim.pause()
		knock_dir = info.direction
		knock_time = 0.5
