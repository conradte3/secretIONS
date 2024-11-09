class_name Hitbox extends Area2D

signal hit_landed(info: HitInfo)

var direction := Vector2.ZERO


func register_hit(info: HitInfo) -> void:
	hit_landed.emit(info)
