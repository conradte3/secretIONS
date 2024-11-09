class_name Player extends CharacterBody2D

@export var speed := 200.0

@onready var bow := $Bow as Bow

var arrow := preload("res://player/projectile.tscn")

var looking_dir = Vector2.RIGHT

var stunned := false

func _ready() -> void:
	bow.shot_released.connect(func(_charged_time: float):
		var inst := arrow.instantiate() as Projectile
		owner.add_child(inst)
		inst.set_direction(bow.mouse_vec)
		inst.global_position = global_position
	)
	$Hurtbox.was_hit.connect(func(hit: HitInfo) -> void:
		velocity = hit.direction * 200.0
		stunned = true
		await get_tree().create_timer(0.5).timeout
		stunned = false
	)

func _physics_process(_delta: float) -> void:
	if not stunned:
		var dir = Input.get_vector("left", "right", "up", "down")
		if dir != Vector2.ZERO and dir != looking_dir:
			looking_dir = dir

		velocity = dir * speed
	move_and_slide()


# Sword + Shield, slash + block-n-rush
func _draw() -> void:
	# Body
	draw_rect(Rect2(-7, 6, 14, 8), Color.WHITE)
	# Head
	draw_circle(Vector2.ZERO, 9.0, Color.WHITE)
	# Horns
	draw_line(Vector2(-7, -5), Vector2(-5, -15), Color.WHITE, 2)
	draw_line(Vector2(7, -5), Vector2(5, -15), Color.WHITE, 2)
	
	# Charge test
	#draw_circle(Vector2.ZERO, charged_time * 10.0 + 10.0, Color.WHITE, false, 1.0, false)
