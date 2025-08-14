extends Area2D

var projectileSpeed = 10
var damage = 60

func _ready() -> void:
	$'.'.area_entered.connect(_area_entered)
	$'.'.body_entered.connect(_body_entered)
	$AnimatedSprite2D.play("Traveling")


func isThingOnSameCollisionLayer(thing):
	var maskLayers = collision_mask
	#print("laser - collision_mask ", collision_mask)
	#print("laser - collision_layer ", collision_layer)
	#print("laser - thing collision_mask ", thing.collision_mask)
	#print("laser - thing collision_layer ", thing.collision_layer)

func _area_entered(area):
	isThingOnSameCollisionLayer(area)
	#print("laser - area", area)
	$".".queue_free()


func _body_entered(body):
	isThingOnSameCollisionLayer(body)
	#print("laser - body", body)
	if "hitByLaser" in body:
		body.hitByLaser($'.')
	$".".queue_free()


func _physics_process(delta: float) -> void:
	$'.'.position += Vector2(projectileSpeed, 0).rotated($'.'.rotation)


















#
