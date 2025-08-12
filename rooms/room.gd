class_name Room
extends Node2D

enum RoomTypes {HALLWAY, SHAFT, ELBOW_UP, ELBOW_DOWN, TJUNCTION_UP, TJUNCTION_DOWN, DEADEND, OPEN, ENCLOSED}


@export var roomType:RoomTypes = RoomTypes.HALLWAY

var roomCoord:Vector2

signal s_doorEntered(toLocation)


func _ready() -> void:
	%TransitionDoor.openRequested.connect(goThroughDoor_try)


func configure(roomType, roomArgsDict):
	print("room - configuring")
	roomCoord = roomArgsDict.coord
	if roomType == RoomTypes.DEADEND:
		if roomArgsDict.right_open:
			$Walls/Right.queue_free()
			$Walls/TilesRight.queue_free()
		elif roomArgsDict.left_open:
			$Walls/Left.queue_free()
			$Walls/TilesLeft.queue_free()
	if roomArgsDict.is_level_exit:
		%TransitionDoor.isLevelExit = roomArgsDict.is_level_exit
		%TransitionDoor.interactionPrompt = "Exit Level"
	else:
		%TransitionDoor.queue_free()
	#elif roomType == RoomTypes.HALLWAY:
		#$Walls/Right.queue_free()
		#$Walls/Left.queue_free()
	#elif roomType == RoomTypes.SHAFT:
		#$Walls/Top.queue_free()
		#$Walls/Bottom.queue_free()

func goThroughDoor_try(toLocation):
	s_doorEntered.emit(toLocation)













#
