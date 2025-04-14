extends Area2D


@export var energyRechargeAmount:float = 20.0
@export var interactionPrompt:String = "Energy Recharge"


func playerInteraction():
	Globals.playerRef.rechargeEnergy(energyRechargeAmount)
	Globals.playerRef.clearInteractionOject()
	$'.'.queue_free()










#
