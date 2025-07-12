extends Area2D


@export var interactionPrompt:String = "Open Crate"




func _ready() -> void:
	pullCameraFocus()
	%MainMenu.s_releaseMenu.connect(releaseScreenFocus)


func playerInteraction():
	#Globals.playerRef.rechargeEnergy(energyRechargeAmount)
	var items = {Inventory.items.fuel : 1, Inventory.items.scrap : 1}
	print("crate - dropping: ", items)
	Inventory.addItemsToPlayerInventory(items)
	Globals.playerRef.clearInteractionOject()
	#$'.'.queue_free()


func pullCameraFocus():
	%ScreenCamera.enabled = true
	print("console - pulling camera")


func releaseScreenFocus():
	Globals.playerIsControllable = true
	%ScreenCamera.enabled = false
	#$'.'.visible = false














#
