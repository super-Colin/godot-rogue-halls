extends Area2D


@export var interactionPrompt:String = "Open Crate"




func _ready() -> void:
	pullCameraFocus()


func playerInteraction():
	#Globals.playerRef.rechargeEnergy(energyRechargeAmount)
	var items = {Inventory.items.fuel : 1, Inventory.items.scrap : 1}
	print("crate - dropping: ", items)
	Inventory.addItemsToPlayerInventory(items)
	Globals.playerRef.clearInteractionOject()
	#$'.'.queue_free()


func pullCameraFocus():
	print("console - pulling camera")

















#
