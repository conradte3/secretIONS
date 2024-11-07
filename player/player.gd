class_name Player extends CharacterBody2D

@export var speed := 100.0

func _physics_process(delta: float) -> void:
	var dir = Input.get_vector("left", "right", "up", "down")
	velocity = dir * speed
	move_and_slide()
