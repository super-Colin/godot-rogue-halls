extends Node2D


#var hallScene = preload("res://rooms/hall.tscn")
var playerScene = preload("res://player.tscn")
var mainShipScene = preload("res://ship_interior.tscn")


func _ready() -> void:
	#%MainMenu.newRun.connect(startNewRun)
	#Globals.s_playerDied.connect(showGameOver)
	#Globals.s_exitLevel.connect(Globals.uiRef.showShipMenu)
	Globals.s_startLevel.connect(startLevel)
	Globals.s_exitShip.connect(startLevel)
	Globals.s_exitLevel.connect(loadInMainShip)
	#printOutInputMap()

func loadInMainShip():
	#var mainShipScene = preload("res://ship_interior.tscn")
	var ship = mainShipScene.instantiate()
	var player = playerScene.instantiate()
	player.position = ship.get_node("PlayerSpawn").position
	ship.add_child(player)
	$'.'.add_child(ship)
	%Level.cleanup()

func startNewRun():
	print("game - starting new run")
	%MainMenu.visible = false
	#$MainShip.queue_free()
	Inventory.newRunSetup()
	Globals.uiRef.showShipMenu()


func startLevel():
	%Level.generateLevel()
	var player = playerScene.instantiate()
	player.position = %Level.get_node("PlayerSpawn").position
	%Level.add_child(player)
	$MainShip.queue_free()
	#%MainMenu.visible = false
	#%ShipMenu.visible = false




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




#func generateLevel():
	## clear existing level
	#for c in %Level.get_children():
		#c.queue_free()
	## make new level node
	#var level = hallScene.instantiate()
	#var player = playerScene.instantiate()
	#player.position = level.getSpawnPoint()
	#%Level.add_child(player)
	## add level to tree
	#%Level.add_child(level)
	#Globals.playerInLevel = true
	#return 


#
#func showGameOver():
	#%MainMenu.visible = true
	#Globals.playerInLevel = false













#
