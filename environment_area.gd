class_name EnvironmentSettings
extends Area2D


@export var infiniteEnergy:bool = true




func _ready() -> void:
	area_entered.connect(entered)
	body_entered.connect(entered)
	area_exited.connect(exited)
	body_exited.connect(exited)



func entered(body):
	#if body == Globals.playerRef:
	if body is Player:
		print("environment - PLAYER entered: ", body)
		body.enteredEnvironment($'.')
	#print("environment - entered: ", body)



func exited(body):
	if body is Player:
		print("environment - PLAYER exited: ", body)
		body.exitedEnvironment($'.')
	#print("environment - entered: ", body)















#
