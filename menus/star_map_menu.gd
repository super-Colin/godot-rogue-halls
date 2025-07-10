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
	#print("starmap menu - xSteps ", xSpacing)
	for x in gridSize.x:
		#newDest.position
		for y in gridSize.y:
			var newDest = mapDestinationScene.instantiate()
			newDest.position = Vector2(xSpacing * (x+1), ySpacing * (y+1) )
			$'.'.add_child(newDest)








#
