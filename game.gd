extends Node2D


var hallScene = preload("res://hall.tscn")
var playerScene = preload("res://player.tscn")


func _ready() -> void:
	%MainMenu.newRun.connect(startNewRun)
	Globals.s_playerDied.connect(showGameOver)
	Globals.s_exitLevel.connect(showShipMenu)
	Globals.s_startLevel.connect(startLevel)


func showShipMenu():
	%MainMenu.visible = false
	%ShipMenu.setupUpgradeTree()
	%ShipMenu.visible = true
	Globals.playerInLevel = false


func startNewRun():
	print("game - starting new run")
	%MainMenu.visible = false
	#generateLevel()
	showShipMenu()

func startLevel():
	generateLevel()
	%MainMenu.visible = false
	%ShipMenu.visible = false

func generateLevel():
	for c in %Level.get_children():
		c.queue_free()
	var level = hallScene.instantiate()
	%Level.add_child(level)
	var player = playerScene.instantiate()
	player.position = level.getSpawnPoint()
	%Level.add_child(player)
	Globals.playerInLevel = true
	return 



func showGameOver():
	%MainMenu.visible = true
	Globals.playerInLevel = false













#
