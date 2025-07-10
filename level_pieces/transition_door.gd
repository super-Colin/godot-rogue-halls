extends Area2D


signal openRequested

@export var isLevelExit:bool = false
@export var isShipExit:bool = false
@export var toForeground = false # to foreground or background
@export var interactionPrompt:String = "Open Door"


func _ready() -> void:
	if isLevelExit:
		interactionPrompt = "Exit Level"
	if isShipExit:
		interactionPrompt = "Start Level"



func playerInteraction():
	if isLevelExit:
		Globals.s_exitLevel.emit()
		return
	if isShipExit:
		Globals.s_exitShip.emit()
		return
	openRequested.emit()
	print("door - open requested")

























#
