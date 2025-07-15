extends Node2D


var roomGridSize = Vector2(1920, 1080)
var path



func getPlayerSpawnPoint():
	return %PlayerSpawn.position


# hallway/shaft (horzontal/vertical)
# elbow, t-juction, no-walls, deadend




#func makePath():
func generateLevel():
	print("level - generating level")
	#var path = makePath()
	var rooms = makeRooms(null)
	for newRoom in rooms:
		$'.'.add_child(newRoom)

func makeRooms(_path=null):
	return [
		makeRoom(Globals.RoomTypes.DEADEND, {"coord":Vector2(0,0), "right_open":true, "is_level_entry":true, }),
		makeRoom(Globals.RoomTypes.HALLWAY, {"coord":Vector2(1,0), }),
		makeRoom(Globals.RoomTypes.DEADEND, {"coord":Vector2(2,0), "left_open":true, "is_level_exit":true, }),
	]


#func makeRoom(roomType:Globals.RoomTypes, roomDic:Dictionary)->PackedScene:
func makeRoom(roomType:Globals.RoomTypes, roomDic:Dictionary):
	roomDic = addRoomDefaultsToDict(roomDic)
	var folderPath
	if roomType == Globals.RoomTypes.DEADEND:
		folderPath = "deadend"
	elif roomType == Globals.RoomTypes.HALLWAY:
		folderPath = "hallway"
	elif roomType == Globals.RoomTypes.SHAFT:
		folderPath = "shaft"
		print("level - is hallway")
	#room.s_doorEntered.connect(movePlayerThroughDoor)
	var theRoomScene = load("res://rooms/"+ folderPath +"/1.tscn")
	var newRoom = theRoomScene.instantiate()
	newRoom.configure(roomType, roomDic)
	newRoom.position = newRoom.roomCoord * roomGridSize
	#return theRoomScene
	return newRoom
	
func addRoomDefaultsToDict(roomDic:Dictionary):
	var defualtDict = {
		"coord":Vector2(0,0),
		"left_open": false,
		"right_open": false,
		"top_open": false,
		"bottom_open": false,
		"enemy_level": 1,
		"is_level_entry": false,
		"is_level_exit": false,
		"is_hallway": false,
		"is_loot_room":false,
		"z_transfer": false,
		"z_transfer_to_coord": Vector3(0,0,0),
		"types": ["ship"] #  "toxic"
	}
	for key in roomDic:
		defualtDict[key] = roomDic[key]
	return defualtDict






func movePlayerThroughDoor(toLocation):
	pass



func cleanup():
	for c in $'.'.get_children():
		c.queue_free()





#
