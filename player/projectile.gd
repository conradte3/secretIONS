class_name Projectile extends Node2D

var velocity := Vector2.ZERO
var speed := 1000.0

@onready var hitbox := $Hitbox as Hitbox

func _ready() -> void:
	hitbox.hit_landed.connect(func(_info: HitInfo):
		queue_free()
	)

func _process(delta: float) -> void:
	global_position += velocity * delta

	if abs(global_position.x) > 1050 or abs(global_position.y) > 1050:
		queue_free()

func set_direction(direction: Vector2) -> void:
	hitbox.direction = direction
	velocity = direction * speed

func _draw() -> void:
	draw_circle(Vector2.ZERO, 4.0, Color.WHITE)
