extends Area2D


#signal openRequested(toLoction)
signal openRequested()

@export var isLevelExit:bool = false
@export var isShipExit:bool = false
@export var toForeground = false # to foreground or background
@export var interactionPrompt:String = "Open Door"

var toCoord

#var toRoomNodeRef:Node = null


func _ready() -> void:
	pass
	#if isLevelExit:
		#interactionPrompt = "Exit Level"
	#if isShipExit:
		#interactionPrompt = "Launch Probe"


func setup(args:Dictionary):
	if not args:
		$'.'.queue_free()
	var used = false
	if args.has("isLevelExit"):
		isLevelExit = args.isLevelExit
		used = true
	if args.has("interactionPrompt"):
		interactionPrompt = args.interactionPrompt
		used = true
	if args.has("toCoord"):
		toCoord = args.toCoord
		used = true
	if not used:
		$'.'.queue_free()


func playerInteraction():
	print("door - open requested")
	if isLevelExit:
		print("door - exiting level")
		Globals.s_exitLevel.emit()
		return
	elif isShipExit:
		Globals.s_exitShip.emit()
		#Globals.s_startLevel.emit()
		return
	#openRequested.emit(toRoomNodeRef)

























#
