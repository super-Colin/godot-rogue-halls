class_name Room
extends Node2D



@export var roomType:Level.RoomTypes = Level.RoomTypes.HALLWAY
@export var canBeRotated = false
@export var canBeMirrored = false



signal s_doorEntered()



func _ready() -> void:
	%TransitionDoor.openRequested.connect(goThroughDoor_try)

func goThroughDoor_try():
	s_doorEntered.emit()


func setAsLevelExit():
	print("room - level exited")


func setAsZTransition(toCoord:Vector2):
	print("room - Z transfer to coord: ", toCoord)

func setupDoor(doorArgs:Dictionary={}):
	%TransitionDoor.setup(doorArgs)






#
