@tool
extends Area2D


var mouseHoveringOn = false
var isSelected = false
var shipIsHere = false
var destinationDict = {}

signal s_selected(selectedNode:Node)



func _ready() -> void:
	if Engine.is_editor_hint():
		return
	#$'.'.mouse_entered.connect(_mouseEntered)
	#$'.'.mouse_exited.connect(_mouseExited)
	$TextureButton.mouse_entered.connect(_mouseEntered)
	$TextureButton.mouse_exited.connect(_mouseExited)
	$'.'.z_index = 0
#$TextureButton

func configureWithDict(destDict):
	destinationDict = destDict
	$DestinationSprite.freeUndisplayedPlanets(destinationDict.type)
	if not "colors" in destinationDict:
		$DestinationSprite.randomizeColors()
		destinationDict.colors = $DestinationSprite.getColors()
		#print("map dest - NEW destinationDict.colors: ", destinationDict.colors)
	else:
		print("map dest - SETTING destinationDict.colors: ", destinationDict.colors)
		$DestinationSprite.setColors(destinationDict.colors)





func _physics_process(delta: float) -> void:
	pass



func _mouseEntered():
	#print("destination - mouse entered")
	mouseHoveringOn = true
	scaleSelf(true)
	$'.'.z_index = 1


func _mouseExited():
	mouseHoveringOn = false
	scaleSelf(false)
	$'.'.z_index = 0


func scaleSelf(scaleUp=true):
	#print("destination - scaling")
	var tween = get_tree().create_tween()
	if scaleUp:
		tween.tween_property($'.', "scale", Vector2(2.0,2.0), 0.25)
	else:
		#$Selected.visible = false
		tween.tween_property($'.', "scale", Vector2(1.0,1.0), 0.25)



func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if mouseHoveringOn and Input.is_action_just_pressed("Accept"):
		selected()
		#print("dest - clicked")







func selected():
	isSelected = true
	$Selected.visible = true
	s_selected.emit($'.')
	#s_selected.emit(destinationDict)

func unselected():
	#pass
	isSelected = false
	$Selected.visible = false


#
