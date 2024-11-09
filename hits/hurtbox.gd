class_name Hurtbox extends Area2D

signal was_hit(info: HitInfo)

func _ready() -> void:
	area_entered.connect(_on_hit)

func _on_hit(other: Area2D) -> void:
	if other is Hitbox:
		var info = HitInfo.new(other, self)
		other.register_hit(info)
		was_hit.emit(info)
