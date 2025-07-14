extends Area2D


signal openRequested(toLoction)

@export var isLevelExit:bool = false
@export var isShipExit:bool = false
@export var toForeground = false # to foreground or background
@export var interactionPrompt:String = "Open Door"


var toRoomNodeRef:Node = null


func _ready() -> void:
	pass
	#if isLevelExit:
		#interactionPrompt = "Exit Level"
	#if isShipExit:
		#interactionPrompt = "Launch Probe"



func playerInteraction():
	if isLevelExit:
		print("door - exiting level")
		Globals.s_exitLevel.emit()
		return
	if isShipExit:
		Globals.s_exitShip.emit()
		#Globals.s_startLevel.emit()
		return
	openRequested.emit(toRoomNodeRef)
	print("door - open requested")

























#
