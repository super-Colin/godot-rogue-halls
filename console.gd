extends Area2D


@export var interactionPrompt:String = "Open Crate"




func _ready() -> void:
	pullCameraFocus()
	%MainMenu.s_releaseMenu.connect(releaseScreenFocus)


func playerInteraction():
	pullCameraFocus()


func pullCameraFocus():
	%ScreenCamera.enabled = true
	print("console - pulling camera")


func releaseScreenFocus():
	Globals.playerIsControllable = true
	%ScreenCamera.enabled = false
	$Screen.mouse_filter = Control.MouseFilter.MOUSE_FILTER_IGNORE
	#$'.'.visible = false











#
