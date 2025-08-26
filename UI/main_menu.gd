extends Control



signal newRun
signal s_releaseMenu


func _ready() -> void:
	#%StartButton.pressed.connect(func():newRun.emit())
	%StartButton.pressed.connect(releaseScreenFocus)
	%OptionsButton.pressed.connect(func():print("main menu - options pressed"))
	#%StartButton.pressed.connect(releaseScreenFocus)
	%StarMapMenu.s_selected.connect(selectedDestination)
	%ConfirmButton.pressed.connect(confirmedDestination)
	%StarMapMenu.makeMap()



func releaseScreenFocus():
	#Globals.playerIsControllable = true
	#$'.'.visible = false
	get_viewport().gui_get_focus_owner().release_focus()
	s_releaseMenu.emit()


func selectedDestination(newDestination):
	%ConfirmButton.disabled = false
	#Globals.confirmedDestination = newDestination
	%DestinationDisplay.visible = true
	%DestinationDisplay.updatePreview(newDestination.destinationDict)
	#%DestinationDisplay.updatePreview(newDestination.destinationDict.duplicate())

func confirmedDestination():
	if "currentlySelected" in %StarMapMenu and %StarMapMenu.currentlySelected:
		Globals.confirmedDestination = %StarMapMenu.currentlySelected
		%StarMapMenu.lockOutNewSelections()
	%ConfirmButton.text = "Confirmed"
	%ConfirmButton.disabled = true
	#%DestinationDisplay.visible = true
