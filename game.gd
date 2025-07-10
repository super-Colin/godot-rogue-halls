extends Node2D


var hallScene = preload("res://hall.tscn")
var playerScene = preload("res://player.tscn")


func _ready() -> void:
	#%MainMenu.newRun.connect(startNewRun)
	#Globals.s_playerDied.connect(showGameOver)
	#Globals.s_exitLevel.connect(Globals.uiRef.showShipMenu)
	Globals.s_startLevel.connect(startLevel)
	#printOutInputMap()


func startNewRun():
	print("game - starting new run")
	%MainMenu.visible = false
	Inventory.newRunSetup()
	Globals.uiRef.showShipMenu()


func startLevel():
	generateLevel()
	%MainMenu.visible = false
	%ShipMenu.visible = false




func printOutInputMap():
	for actionName in InputMap.get_actions():
		print("%s:" % actionName)
		for inputEvent in InputMap.action_get_events(actionName):
			print(" %s" % inputEvent.as_text())


#func showShipMenu():
	#%MainMenu.visible = false
	#%ShipMenu.setupUpgradeTree()
	#%ShipMenu.visible = true
	#Globals.playerInLevel = false




func generateLevel():
	# clear existing level
	for c in %Level.get_children():
		c.queue_free()
	# make new level node
	var level = hallScene.instantiate()
	var player = playerScene.instantiate()
	player.position = level.getSpawnPoint()
	%Level.add_child(player)
	# add level to tree
	%Level.add_child(level)
	Globals.playerInLevel = true
	return 


#
#func showGameOver():
	#%MainMenu.visible = true
	#Globals.playerInLevel = false













#
