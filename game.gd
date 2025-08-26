extends Node2D


#var hallScene = preload("res://rooms/hall.tscn")
var playerScene = preload("res://player/player.tscn")
var mainShipScene = preload("res://levels/ship_interior.tscn")


func _ready() -> void:
	#%MainMenu.newRun.connect(startNewRun)
	#Globals.s_playerDied.connect(showGameOver)
	#Globals.s_exitLevel.connect(Globals.uiRef.showShipMenu)
	Globals.s_startLevel.connect(startLevel)
	Globals.s_exitShip.connect(startLevel)
	Globals.s_exitLevel.connect(loadInMainShip) # emitted from transition door or room
	#printOutInputMap()

func loadInMainShip():
	#var mainShipScene = preload("res://ship_interior.tscn")
	var ship = mainShipScene.instantiate()
	var player = playerScene.instantiate()
	player.position = ship.get_node("PlayerSpawn").position
	ship.add_child(player)
	$'.'.add_child(ship)
	%Level.cleanup()
	$Darkness.visible = false
	Globals.s_playerLightsOff.emit()

func startNewRun():
	print("game - starting new run")
	%MainMenu.visible = false
	#$MainShip.queue_free()
	Inventory.newRunSetup()
	Globals.uiRef.showShipMenu()


func startLevel():
	%Level.generateLevel()
	var player = playerScene.instantiate()
	#player.position = %Level.get_node("PlayerSpawn").position
	player.position = %Level.getPlayerSpawnPoint()
	%Level.add_child(player)
	$MainShip.queue_free()
	$Darkness.visible = true
	Globals.s_playerLightsOn.emit()
	#%MainMenu.visible = false
	#%ShipMenu.visible = false
	




func printOutInputMap():
	for actionName in InputMap.get_actions():
		print("%s:" % actionName)
		for inputEvent in InputMap.action_get_events(actionName):
			print(" %s" % inputEvent.as_text())




func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		Globals.pauseGame()












#
