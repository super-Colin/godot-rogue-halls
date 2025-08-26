extends Area2D


#signal openRequested(toLoction)
signal openRequested

@export var isLevelExit:bool = false
@export var isShipExit:bool = false
@export var toForeground = false # to foreground or background
@export var interactionPrompt:String = "Open Door"





func playerInteraction():
	print("door - open requested")
	if isLevelExit:
		print("door - exiting level")
		Globals.s_exitLevel.emit()
	elif isShipExit:
		Globals.s_exitShip.emit()
	else:
		openRequested.emit()





#
