extends Control



signal newRun
signal s_releaseMenu


func _ready() -> void:
	#%StartButton.pressed.connect(func():newRun.emit())
	%StartButton.pressed.connect(func():s_releaseMenu.emit())
	%OptionsButton.pressed.connect(func():print("main menu - options pressed"))
	#%StartButton.pressed.connect(releaseScreenFocus)
	%StarMapMenu.s_selected.connect(selectedDestination)
	%ConfirmButton.pressed.connect(confirmedDestination)


#func releaseScreenFocus():
	#Globals.playerIsControllable = true
	##$'.'.visible = false


func selectedDestination(newDestination):
	%ConfirmButton.disabled = false
	#Globals.confirmedDestination = newDestination
	%DestinationDisplay.visible = true

func confirmedDestination():
	if "currentlySelected" in %StarMapMenu and %StarMapMenu.currentlySelected:
		Globals.confirmedDestination = %StarMapMenu.currentlySelected
		%StarMapMenu.lockOutNewSelections()
	%ConfirmButton.text = "Confirmed"
	%ConfirmButton.disabled = true
	#%DestinationDisplay.visible = true






func _physics_process(delta: float) -> void:
	#if Input.get_axis("Move_Left", "Move_Right") != 0:
		#print("menu - player moved")
	pass
