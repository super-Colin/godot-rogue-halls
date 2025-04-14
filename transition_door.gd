extends Area2D


signal openRequested

@export var isLevelExit:bool = true
@export var toForeground = false # to foreground or background
@export var interactionPrompt:String = "Open Door"



func playerInteraction():
	openRequested.emit()
	print("door - open requested")























#
