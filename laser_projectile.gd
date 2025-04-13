extends Area2D

@export var projectileSpeed = 10


func _physics_process(delta: float) -> void:
	$'.'.position += Vector2(projectileSpeed, 0).rotated($'.'.rotation)















#
