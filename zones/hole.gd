extends ZoneChanger

@export var radius : float = 32.0

func _ready() -> void:
	var shape = CircleShape2D.new()
	shape.radius = radius
	$CollisionShape2D.shape = shape

	super()

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color.BLACK)
