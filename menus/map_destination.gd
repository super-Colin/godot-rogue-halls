extends Area2D
#extends Button


var mouseHoveringOn = false
var isSelected = false
var isHere = false

signal s_selected(selectedNode:Node)
#/root/Game/MainShip/Console/Screen/ScreenScale/MainMenu/MarginContainer/StarMapMenu/MapDestination/CollisionShape2D
func _ready() -> void:
	#$'.'.mouse_entered.connect(_mouseEntered)
	#$'.'.mouse_exited.connect(_mouseExited)
	$TextureButton.mouse_entered.connect(_mouseEntered)
	$TextureButton.mouse_exited.connect(_mouseExited)
	choosePlanetToDisplay()
	$'.'.z_index = 0
#$TextureButton

func _physics_process(delta: float) -> void:
	pass



func _mouseEntered():
	print("destination - mouse entered")
	mouseHoveringOn = true
	scaleSelf(true)
	$'.'.z_index = 1


func _mouseExited():
	mouseHoveringOn = false
	scaleSelf(false)
	$'.'.z_index = 0


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

func choosePlanetToDisplay():
	var seed = randi() % 5
	if seed == 0:
		$GasPlanet.queue_free()
		$Galaxy.queue_free()
		$Terran.queue_free()
		$Star.queue_free()
	elif seed == 1:
		$GasPlanet.queue_free()
		$BlackHole.queue_free()
		$Terran.queue_free()
		$Star.queue_free()
	elif seed == 2:
		$Galaxy.queue_free()
		$BlackHole.queue_free()
		$Terran.queue_free()
		$Star.queue_free()
	elif seed == 3:
		$GasPlanet.queue_free()
		$Galaxy.queue_free()
		$BlackHole.queue_free()
		$Star.queue_free()
	elif seed == 4:
		$GasPlanet.queue_free()
		$Galaxy.queue_free()
		$Terran.queue_free()
		$BlackHole.queue_free()




func selected():
	isSelected = true
	$Selected.visible = true
	s_selected.emit($'.')

func unselected():
	isSelected = false
	$Selected.visible = false


#
