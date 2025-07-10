extends Node


var paused = true # always start with main menu up
var currentPauseMenu = "main"


#get_viewport().get_camera_2d()
func _ready() -> void:
	$UiCamera
	%MainMenu.s_releaseMenu.connect(unpause)
	Globals
	Globals.uiRef = $'.'
	Globals.s_playerDied.connect(showGameOver)
	Globals.s_exitLevel.connect(showShipMenu)

func pause():
	if currentPauseMenu == "main":
		%MainMenu.visible = true
	Globals.playerIsControllable = false

func unpause():
	if currentPauseMenu == "main":
		%MainMenu.visible = false
	Globals.playerIsControllable = true



func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		unpause()


func showShipMenu():
	%MainMenu.visible = false
	%ShipMenu.setupUpgradeTree()
	%ShipMenu.visible = true
	Globals.playerInLevel = false


func showGameOver():
	%MainMenu.visible = true
	Globals.playerInLevel = false














#
