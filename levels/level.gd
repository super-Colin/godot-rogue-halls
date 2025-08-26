class_name Level
extends Node2D

enum RoomTypes {
	HALLWAY, SHAFT, OPEN,
	DEADEND_LEFT, DEADEND_RIGHT, DEADEND_UP, DEADEND_DOWN, # going into direction, LEFT = ]
	LJUNCTION_LEFT_UP, LJUNCTION_LEFT_DOWN, LJUNCTION_RIGHT_UP, LJUNCTION_RIGHT_DOWN,
	TJUNCTION_LEFT, TJUNCTION_RIGHT, TJUNCTION_UP, TJUNCTION_DOWN, 
}




var roomGridCellSize = Vector2(1920, 1080)
var path
#var grid = {}

var levelEndRoomRef
#var levelStartRoomRef



func generateLevel():
	print("level - generating level, vector up: ", Vector2.UP)
	path = generatePath(3)
	print("level - path is: ", path)
	var coords = Vector2.ZERO
	var previousDirection = Vector2.ZERO
	var zLayers = 1
	for zLayer in zLayers:
		for pathI in path.size():
			coords += previousDirection # starts at 0
			#previousDirection = direction
			var newRoom = makeRoomForPath(previousDirection, path[pathI], coords)
			$'.'.add_child(newRoom)
			previousDirection = path[pathI]
			if zLayer+1 == zLayers and pathI+1 == path.size():
				#newRoom.isShipExit = true
				#newRoom.s_doorEntered.connect(func():Globals.s_exitLevel.emit())
				newRoom.setupDoor(exitDoorDict())
			else:
				newRoom.setupDoor()


func exitDoorDict():
	return {
		"isLevelExit" : true,
		"interactionPrompt" : "Exit Level"
		#"toCoord":Vector3.FORWARD
	}


func makeRoomForPath(previousDirection, nextDirection, coords):
	var roomType = getRoomType(previousDirection, nextDirection)
	var newRoom = loadRoomType(roomType)
	newRoom.position = coords * roomGridCellSize
	print("level - making room type: ", RoomTypes.keys()[roomType], ", from prev: ", previousDirection, " to next: ", nextDirection," . coords: ", coords)
	return newRoom


func invertY(vec:Vector2):
	return Vector2(vec.x, -vec.y)

#region Initial Path
func generatePath(maxLength = 10):
#func generatePath(maxLength = 10)->Array[Vector2]:
	var grid = {}
	var path = []
	var currentPosition = Vector2.ZERO
	var previousDirection = Vector2.ZERO
	for r in maxLength:
		var nextDirection = randomDirection(previousDirection)
		var newPosition = currentPosition + nextDirection
		# do better checking here
		if grid.has(newPosition):
			continue
		path.append(nextDirection)
		previousDirection = nextDirection
		#var roomType = getRoomType(previousDirection, nextDirection)
	path.append(Vector2.ZERO)
	return path

func randomDirection(previousDirection:Vector2):
	var directions = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
	if previousDirection:
		directions.erase(-previousDirection) # opposite direction or current travel
	return directions[randi() % directions.size()]

#endregion Initial Path


#region Make Room
#func makeRoom(roomType:RoomTypes, roomDic:Dictionary={}):
func loadRoomType(roomType:RoomTypes, modifiers:Dictionary={}):
	#var roomDic = addRoomDefaultsToDict({})
	var folderPath
	match roomType:
		RoomTypes.HALLWAY: folderPath = "hallway"
		RoomTypes.SHAFT: folderPath = "shaft"
		RoomTypes.OPEN: folderPath = "open"
		RoomTypes.DEADEND_LEFT: folderPath = "deadend/left"
		RoomTypes.DEADEND_RIGHT: folderPath = "deadend/right"
		RoomTypes.DEADEND_UP: folderPath = "deadend/up"
		RoomTypes.DEADEND_DOWN: folderPath = "deadend/down"
		RoomTypes.LJUNCTION_LEFT_UP: folderPath = "l_junction/left_up"
		RoomTypes.LJUNCTION_LEFT_DOWN: folderPath = "l_junction/left_down"
		RoomTypes.LJUNCTION_RIGHT_UP: folderPath = "l_junction/right_up"
		RoomTypes.LJUNCTION_RIGHT_DOWN: folderPath = "l_junction/right_down"
		RoomTypes.TJUNCTION_LEFT: folderPath = "t_junction/left"
		RoomTypes.TJUNCTION_RIGHT: folderPath = "t_junction/right"
		RoomTypes.TJUNCTION_UP: folderPath = "t_junction/up"
		RoomTypes.TJUNCTION_DOWN: folderPath = "t_junction/down"
	#room.s_doorEntered.connect(movePlayerThroughDoor)
	#print("level - loading room: ", folderPath)
	var theRoomScene = load("res://rooms/"+ folderPath +"/1.tscn")
	var newRoom = theRoomScene.instantiate()
	#newRoom.configure(roomType, roomDic)
	#newRoom.position = newRoom.roomCoord * roomGridCellSize
	#return theRoomScene
	return newRoom

func addRoomDefaultsToDict(roomDic:Dictionary):
	var defualtDict = {
		"coord":Vector2(0,0),
		#"left_open": false,
		#"right_open": false,
		#"top_open": false,
		#"bottom_open": false,
		"enemy_level": 1,
		"is_level_entry": false,
		"is_level_exit": false,
		#"is_hallway": false,
		"is_loot_room":false,
		"z_transfer": false,
		"z_transfer_to_coord": Vector3(0,0,0),
		"types": ["ship"] #  "toxic"
	}
	for key in roomDic:
		defualtDict[key] = roomDic[key]
	return defualtDict

#endregion Make Room







func getPlayerSpawnPoint():
	return %PlayerSpawn.position







func movePlayerThroughDoor(toLocation):
	pass



#func getRoomType(previousDirection:Vector2, nextDirection:Vector2, branches:Array[Vector2] = []):
func getRoomType(previousDirection:Vector2, nextDirection:Vector2)->RoomTypes:
	#print("level - room ", previousDirection, ", ", previousDirection.rotated(0.5))
	#print("level - room ", previousDirection, ", ", nextDirection)
	if previousDirection == Vector2.ZERO:
		match nextDirection:
			Vector2.UP: return RoomTypes.DEADEND_UP
			Vector2.DOWN: return RoomTypes.DEADEND_DOWN
			Vector2.LEFT: return RoomTypes.DEADEND_LEFT
			Vector2.RIGHT: return RoomTypes.DEADEND_RIGHT
	elif previousDirection == Vector2.LEFT: # coming from left 
		match nextDirection:
			Vector2.UP: return RoomTypes.LJUNCTION_RIGHT_UP
			Vector2.DOWN: return RoomTypes.LJUNCTION_RIGHT_DOWN
			Vector2.LEFT: return RoomTypes.HALLWAY
			Vector2.RIGHT: return RoomTypes.HALLWAY
			Vector2.ZERO: return RoomTypes.DEADEND_RIGHT
	elif previousDirection == Vector2.RIGHT:
		match nextDirection:
			Vector2.UP: return RoomTypes.LJUNCTION_LEFT_UP
			Vector2.DOWN: return RoomTypes.LJUNCTION_LEFT_DOWN
			Vector2.LEFT: return RoomTypes.HALLWAY
			Vector2.RIGHT: return RoomTypes.HALLWAY
			Vector2.ZERO: return RoomTypes.DEADEND_LEFT
	elif previousDirection == Vector2.UP: 
		match nextDirection:
			Vector2.UP: return RoomTypes.SHAFT
			Vector2.DOWN: return RoomTypes.SHAFT
			Vector2.LEFT: return RoomTypes.LJUNCTION_LEFT_DOWN
			Vector2.RIGHT: return RoomTypes.LJUNCTION_RIGHT_DOWN
			Vector2.ZERO: return RoomTypes.DEADEND_DOWN
	elif previousDirection == Vector2.DOWN:
		match nextDirection:
			Vector2.UP: return RoomTypes.SHAFT
			Vector2.DOWN: return RoomTypes.SHAFT
			Vector2.LEFT: return RoomTypes.LJUNCTION_LEFT_UP
			Vector2.RIGHT: return RoomTypes.LJUNCTION_RIGHT_UP
			Vector2.ZERO: return RoomTypes.DEADEND_UP
	print("level - getRoomType: ", previousDirection, nextDirection, ", returning fallback")
	return RoomTypes.OPEN # fall back




func cleanup():
	for c in $'.'.get_children():
		c.queue_free()





#
