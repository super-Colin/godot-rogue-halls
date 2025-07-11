extends Area2D
#extends Button


var mouseHoveringOn = false
var isSelected = false

signal s_selected(selectedNode:Node)

func _ready() -> void:
	#$'.'.mouse_entered.connect(_mouseEntered)
	#$'.'.mouse_exited.connect(_mouseExited)
	$TextureButton.mouse_entered.connect(_mouseEntered)
	$TextureButton.mouse_exited.connect(_mouseExited)
	pass
#$TextureButton

func _physics_process(delta: float) -> void:
	pass



func _mouseEntered():
	print("destination - mouse entered")
	mouseHoveringOn = true
	scaleSelf(true)


func _mouseExited():
	mouseHoveringOn = false
	scaleSelf(false)


func scaleSelf(scaleUp=true):
	print("destination - scaling up")
	var tween = get_tree().create_tween()
	if scaleUp:
		tween.tween_property($'.', "scale", Vector2(2.0,2.0), 0.25)
	else:
		#$Selected.visible = false
		tween.tween_property($'.', "scale", Vector2(1.0,1.0), 0.25)



func _process(delta: float) -> void:
	if mouseHoveringOn and Input.is_action_just_pressed("Accept"):
		selected()
		print("dest - clicked")




func selected():
	isSelected = true
	$Selected.visible = true
	s_selected.emit($'.')

func unselected():
	isSelected = false
	$Selected.visible = false


#
