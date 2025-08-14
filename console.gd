extends Area2D


@export var interactionPrompt:String = "Open Crate"

var isActiveFocus


func _ready() -> void:
	#pullCameraFocus()
	%MainMenu.s_releaseMenu.connect(releaseScreenFocus)


func playerInteraction():
	if isActiveFocus:
		releaseScreenFocus()
	else:
		pullCameraFocus()

func pullCameraFocus():
	#%ScreenCamera.enabled = true
	Utilities.transitionCameras(%ScreenCamera)
	print("console - pulling camera")
	%MouseBlocker.visible = false
	isActiveFocus = true


func releaseScreenFocus():
	print("console - releasing focus")
	Globals.playerIsControllable = true
	#%ScreenCamera.enabled = false
	Utilities.transitionCameras(Globals.playerRef.camera)
	#$Screen.mouse_filter = Control.MouseFilter.MOUSE_FILTER_IGNORE
	%MouseBlocker.visible = true
	isActiveFocus = false
	#$'.'.visible = false











#
