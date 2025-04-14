extends Node2D



@export var energyRechargeAmount:float = 20.0
@export var interactionPrompt:String = "Open Crate"


func playerInteraction():
	#Globals.playerRef.rechargeEnergy(energyRechargeAmount)
	var items = {Inventory.items.fuel : 1, Inventory.items.scrap : 1}
	print("crate - dropping: ", items)
	Inventory.addItemsToPlayerInventory(items)
	Globals.playerRef.clearInteractionOject()
	$'.'.queue_free()






















#
