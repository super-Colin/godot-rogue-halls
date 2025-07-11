@tool
extends Control

const mapDestinationScene = preload("res://menus/map_destination.tscn")




@export_tool_button("Make Grid")
var makeGridAction = makeGridMarkers

@export var gridSize:Vector2 = Vector2(10, 5)



func _ready() -> void:
	if Engine.is_editor_hint():
		return
	makeGridMarkers()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return



func makeMap():
	return


func makeGridMarkers():
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
			var newDest = mapDestinationScene.instantiate()
			newDest.position = Vector2(xSpacing * (x+1), ySpacing * (y+1) )
			#var newDestCoord = chooseCoordsForThisColumn(x, y)
			newDest.s_selected.connect(setNewSelected)
			$'.'.add_child(newDest)

var currentlySelected:Node = null
func setNewSelected(newSelected:Node):
	if currentlySelected:
		currentlySelected.unselected()
	currentlySelected = newSelected
	pass


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
