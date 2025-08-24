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
var grid = {}





func generateLevel():
	print("level - generating level")
	path = generatePath(3)
	var coords = Vector2.ZERO
	var previousDirection = Vector2.ZERO
	for direction in path:
		coords += previousDirection # starts at 0
		var roomType = getRoomType(previousDirection, direction)
		print("level - coords: ", coords, ", roomType: ", roomType)
		var room = makeRoom(roomType)
		previousDirection = direction


#region Initial Path
func generatePath(maxLength = 10):
#func generatePath(maxLength = 10)->Array[Vector2]:
	var currentPosition = Vector2.ZERO
	var path = []
	var previousDirection = Vector2.ZERO
	for r in maxLength:
		var nextDirection = randomDirection(previousDirection)
		var newPosition = currentPosition + nextDirection
		# do better checking here
		if grid.has(newPosition):
			continue
		var roomType = getRoomType(previousDirection, nextDirection)

func randomDirection(previousDirection:Vector2):
	var directions = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
	if previousDirection:
		directions.erase(-previousDirection) # opposite direction or current travel
	return directions[randi() % directions.size()]

#endregion Initial Path


#region Make Room
#func makeRoom(roomType:RoomTypes, roomDic:Dictionary={}):
func makeRoom(roomType:RoomTypes, modifiers:Dictionary={}):
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
	var theRoomScene = load("res://rooms/"+ folderPath +"/1.tscn")
	var newRoom = theRoomScene.instantiate()
	#newRoom.configure(roomType, roomDic)
	newRoom.position = newRoom.roomCoord * roomGridCellSize
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












#
#
#func makeRooms(_path=null):
	##return layout1()
	#return layout2()





#
#
#func layout1():
	#return [
		#makeRoom(Globals.RoomTypes.DEADEND, {"coord":Vector2(0,0), "right_open":true, "is_level_entry":true, }),
		#makeRoom(Globals.RoomTypes.HALLWAY, {"coord":Vector2(1,0), }),
		#makeRoom(Globals.RoomTypes.DEADEND, {"coord":Vector2(2,0), "left_open":true, "is_level_exit":true, }),
	#]
#



















func getPlayerSpawnPoint():
	return %PlayerSpawn.position


# hallway/shaft (horzontal/vertical)
# elbow, t-juction, no-walls, deadend












#
#func layout2():
	#return [
		#makeRoom(Globals.RoomTypes.DEADEND, {"coord":Vector2(0,0), "right_open":true, "is_level_entry":true, }),
		#makeRoom(Globals.RoomTypes.HALLWAY, {"coord":Vector2(1,0), }),
		#makeRoom(Globals.RoomTypes.DEADEND, {"coord":Vector2(2,0), "left_open":true, "is_level_exit":true, }),
	#]
#
#





func movePlayerThroughDoor(toLocation):
	pass



#func getRoomType(previousDirection:Vector2, nextDirection:Vector2, branches:Array[Vector2] = []):
func getRoomType(previousDirection:Vector2, nextDirection:Vector2)->RoomTypes:
	print("level - room ", previousDirection, ", ", previousDirection.rotated(0.5))
	if previousDirection == Vector2.ZERO:
		match nextDirection:
			Vector2.UP: return RoomTypes.DEADEND_DOWN
			Vector2.DOWN: return RoomTypes.DEADEND_UP
			Vector2.LEFT: return RoomTypes.DEADEND_RIGHT
			Vector2.RIGHT: return RoomTypes.DEADEND_LEFT
	elif previousDirection == Vector2.LEFT: # coming from left 
		match nextDirection:
			Vector2.UP: return RoomTypes.LJUNCTION_LEFT_UP
			Vector2.DOWN: return RoomTypes.LJUNCTION_LEFT_DOWN
			#Vector2.LEFT: return RoomTypes.DEADEND_RIGHT
			Vector2.RIGHT: return RoomTypes.HALLWAY
	elif previousDirection == Vector2.RIGHT:
		match nextDirection:
			Vector2.UP: return RoomTypes.LJUNCTION_RIGHT_UP
			Vector2.DOWN: return RoomTypes.LJUNCTION_RIGHT_DOWN
			Vector2.LEFT: return RoomTypes.HALLWAY
			#Vector2.RIGHT: return RoomTypes.DEADEND_LEFT
	elif previousDirection == Vector2.UP: 
		match nextDirection:
			#Vector2.UP: return RoomTypes.SHAFT
			Vector2.DOWN: return RoomTypes.SHAFT
			Vector2.LEFT: return RoomTypes.LJUNCTION_LEFT_UP
			Vector2.RIGHT: return RoomTypes.LJUNCTION_RIGHT_UP
	elif previousDirection == Vector2.DOWN:
		match nextDirection:
			Vector2.UP: return RoomTypes.SHAFT
			#Vector2.DOWN: return RoomTypes.SHAFT
			Vector2.LEFT: return RoomTypes.LJUNCTION_LEFT_DOWN
			Vector2.RIGHT: return RoomTypes.LJUNCTION_RIGHT_DOWN
	return RoomTypes.OPEN # fall back




func cleanup():
	for c in $'.'.get_children():
		c.queue_free()





#
