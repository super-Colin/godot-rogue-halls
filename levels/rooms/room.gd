class_name Room
extends Node2D



@export var roomType:Level.RoomTypes = Level.RoomTypes.HALLWAY
@export var canBeRotated = false
@export var canBeMirrored = false

var isLevelExit:bool = false
var isShipExit:bool = false

var toCoord

signal s_doorEntered
signal s_zTransitionRequested



func _ready() -> void:
	%TransitionDoor.openRequested.connect(goThroughDoor_try)



func setup(args:Dictionary = {}):
	if not args:
		%TransitionDoor.queue_free()
	var used = false
	if args.has("isLevelExit"):
		isLevelExit = args.isLevelExit
		used = true
	if args.has("interactionPrompt"):
		%TransitionDoor.interactionPrompt = args.interactionPrompt
		used = true
	if args.has("toCoord"):
		toCoord = args.toCoord
		used = true
	if not used:
		%TransitionDoor.queue_free()



func goThroughDoor_try():
	if isLevelExit:
		Globals.s_exitLevel.emit()
	s_doorEntered.emit()

func zTransitionRequested(toCoord):
	s_zTransitionRequested.emit()


func getEnemySpawn():
	return $EnemySpawn

func getPlayerSpawn():
	return $PlayerSpawn










func setAsLevelExit():
	print("room - level exited")


func setAsZTransition(toCoord:Vector2):
	print("room - Z transfer to coord: ", toCoord)

#func setupDoor(doorArgs:Dictionary={}):
	#%TransitionDoor.setup(doorArgs)






#
