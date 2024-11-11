class_name Tether extends Node2D

@export var enemy_type : PackedScene
@onready var default_enemy := preload("res://enemies/basic_enemy.tscn") as PackedScene

func _ready() -> void:
	if not enemy_type:
		enemy_type = default_enemy

	spawn.call_deferred()

func spawn() -> void:
	var inst = enemy_type.instantiate() as Enemy
	owner.add_child(inst)
	inst.global_position = global_position
	inst.center = self

func _draw() -> void:
	draw_circle(Vector2.ZERO, 8.0, Color.CRIMSON, false, 2.0, true)
