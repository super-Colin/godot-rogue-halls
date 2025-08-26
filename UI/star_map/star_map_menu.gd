@tool
extends Control


const mapDestinationScene = preload("res://UI/star_map/map_destination.tscn")



@export_tool_button("Make Map")
var makeMapAction = makeMap
@export var gridSize:Vector2 = Vector2(10, 5)


var currentlySelected:Node = null
#var currentlySelected = null
var lockedOut = false

signal s_selected(destinationDict)




func _ready() -> void:
	if Engine.is_editor_hint():
		return
	#makeMap()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return


func lockOutNewSelections():
	lockedOut = true


func makeMap():
	return makeGrid()


func makeGrid():
	for c in $'.'.get_children():
		c.free()
	var xSpacing = $'.'.size.x / (gridSize.x + 1)
	var ySpacing = $'.'.size.y / (gridSize.y + 1)
	var colCoords:Array[int] = []
	#print("starmap menu - xSteps ", xSpacing)
	for x in gridSize.x:
		colCoords = chooseCoordsForThisColumn(x, colCoords, gridSize.y)
		#for y in gridSize.y:
		for y in colCoords:
			var newDestDict = makePlanetDict( (x*y)+y + 1 )
			var newDest = mapDestinationScene.instantiate()
			newDest.position = Vector2(xSpacing * (x+1), ySpacing * (y+1) )
			newDest.configureWithDict(newDestDict)
			
			#var newDestCoord = chooseCoordsForThisColumn(x, y)
			if not Engine.is_editor_hint():
				newDest.s_selected.connect(setNewSelected)
			$'.'.add_child(newDest)
			#newDest.owner = $'.'

func makePlanetDict(destSeed)->Dictionary:
	print("star map - making planet dict. seed: ", destSeed)
	var destType = decidePlanetType(destSeed)
	var destName = decidePlanetName(destSeed, destType)
	return {
		"destSeed":destSeed,
		"type":destType, 
		"name":destName,
		"description":"Default Description",
	}

func decidePlanetName(destSeed, type):
	if type == Globals.DestinationTypes.TERRAN:
		return "Pt-" + str( int(destSeed*999)%632 )
	elif type == Globals.DestinationTypes.GAS_PLANET:
		return "Pg-" + str( int(destSeed*999)%537 )
	elif type == Globals.DestinationTypes.GALAXY:
		return "Gl-" + str( int(destSeed*999)%833 )
	elif type == Globals.DestinationTypes.BLACKHOLE:
		return "Bh-" + str( int(destSeed*999)%239 )
	elif type == Globals.DestinationTypes.STAR:
		return "Sr-" + str( int(destSeed*999)%735 )

func decidePlanetType(destSeed):
	destSeed = int(destSeed * 999) % 5
	if destSeed == 0:
		return Globals.DestinationTypes.TERRAN
	elif destSeed == 1:
		return Globals.DestinationTypes.GAS_PLANET
	elif destSeed == 2:
		return Globals.DestinationTypes.GALAXY
	elif destSeed == 3:
		return Globals.DestinationTypes.BLACKHOLE
	elif destSeed == 4:
		return Globals.DestinationTypes.STAR


func setNewSelected(newSelected:Node):
	#if lockedOut:
		#newSelected.unselected()
		#return
	if currentlySelected and currentlySelected == newSelected:
		print("star map - is currently selected dest")
		return
	if not currentlySelected:
		currentlySelected = newSelected
		s_selected.emit(currentlySelected)
	#elif currentlySelected:
	else:
		currentlySelected.unselected()
		currentlySelected = newSelected
		s_selected.emit(currentlySelected)



func chooseCoordsForThisColumn(timeAxis_current:int, timeAxis_currentAvailable:Array[int], choiceAxisMax:int=5, paths:int=0)->Array[int]:
	if timeAxis_current == 0 :
		#print("starmap menu - chooseCoordsForThisColumn: ", Vector2(timeAxis_currentAvailable, int(choiceAxisMax/2) ))
		return [int(choiceAxisMax/2)] # return the middle of the road coord
	if paths == 0:
		paths = timeAxis_currentAvailable.size() * 2 # double available paths by default
		if paths > choiceAxisMax:
			paths = choiceAxisMax
	return[1]






#
