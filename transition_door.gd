extends Area2D


signal openRequested

@export var isLevelExit:bool = true
@export var toForeground = false # to foreground or background
@export var interactionPrompt:String = "Open Door"


func _ready() -> void:
	if isLevelExit:
		interactionPrompt = "Exit Level"

func playerInteraction():
	if isLevelExit:
		Globals.s_exitLevel.emit()
		return
	openRequested.emit()
	print("door - open requested")

























#
