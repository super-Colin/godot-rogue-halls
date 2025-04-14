extends Node2D




func _ready() -> void:
	%MainMenu.newRun.connect(startNewRun)
	Globals.s_playerDied.connect(showGameOver)



func startNewRun():
	print("game - starting new run")
	%MainMenu.visible = false
	generateLevel()

func generateLevel():
	return 



func showGameOver():
	%MainMenu.visible = true













#
