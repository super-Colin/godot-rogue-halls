extends Area2D

@export var projectileSpeed = 10


func _ready() -> void:
	$'.'.area_entered.connect(_area_entered)
	$'.'.body_entered.connect(_body_entered)



func _area_entered(area):
	print("laser - area", area)
	$".".queue_free()


func _body_entered(body):
	print("laser - body", body)
	$".".queue_free()


func _physics_process(delta: float) -> void:
	$'.'.position += Vector2(projectileSpeed, 0).rotated($'.'.rotation)


















#
