class_name Room
extends Node2D

#var defualtDict = {
	#"coord":Vector2(0,0),
	#"left_open": false,
	#"right_open": false,
	#"top_open": false,
	#"bottom_open": false,
	#"enemy_level": 1,
	#"is_level_entry": false,
	#"is_level_exit": false,
	#"is_hallway": false,
	#"is_loot_room":false,
	#"z_transfer": false,
	#"z_transfer_to_coord": Vector3(0,0,0),
	#"types": ["ship"] #  "toxic"
#}







@export var roomType:Level.RoomTypes = Level.RoomTypes.HALLWAY
@export var canBeRotated = false
@export var canBeMirrored = false

var roomCoord:Vector2

signal s_doorEntered(toLocation)


func _ready() -> void:
	%TransitionDoor.openRequested.connect(goThroughDoor_try)


func configure(roomType, roomArgsDict):
	print("room - configuring")
	roomCoord = roomArgsDict.coord
	if roomType == Level.RoomTypes.DEADEND_LEFT:
		$Walls/Right.queue_free()
		$Walls/TilesRight.queue_free()
	elif roomType == Level.RoomTypes.DEADEND_RIGHT:
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
