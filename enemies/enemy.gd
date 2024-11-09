class_name Enemy extends CharacterBody2D

@export var speed := 100.0

var target: Node2D
var center: Node2D

var stunned := false

func _ready() -> void:
	center = get_tree().get_first_node_in_group("center_point")
	$Hurtbox.was_hit.connect(func(hit: HitInfo) -> void:
		velocity = hit.direction * 200.0
		stunned = true
		await get_tree().create_timer(0.5).timeout
		stunned = false
	)

func _physics_process(_delta: float) -> void:
	if not stunned:
		var dir = choose_direction()
		velocity = dir * speed
	move_and_slide()

func choose_direction() -> Vector2:
	var total_force := Vector2.ZERO
	
	# -> Chasing (when target aquired)
	if target:
		var chasing_force = 1.0
		var chase_dir = global_position.direction_to(target.global_position)
		total_force += chase_dir * chasing_force

	# -> Centering (for basic arena)
	if center:
		var centering_force = 0.5
		var center_dir = global_position.direction_to(center.global_position)
		total_force += center_dir * centering_force

	# Edge avoidance (for complex arena)
	# Separation (for multiple enemies)
	
	return total_force.normalized()

func _on_target_detector_body_entered(body: Node2D) -> void:
	target = body