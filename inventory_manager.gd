extends Node


var shipInventory = {
	Inventory.items.fuel:1,
	Inventory.items.scrap:3,
}


func canShipAffordCost(costDict)->bool:
	for item in costDict:
		if not shipInventory.has(item):
			return false
		if costDict[item] > shipInventory[item]:
			return false
	print("inv - can afford: ", costDict)
	return true

func payCostFromShipInventory(costDict):
	for item in costDict:
		shipInventory[item] -= costDict[item]

var playerInventory = {}
var itemsInPlayerInventory = 0

enum items {fuel, scrap, core}

var fuelTexture = preload("res://pattern_30.png")
var scrapTexture = preload("res://pattern_37.png")
var coreTexture = preload("res://pattern_46.png")

var texMap = {
	Inventory.items.fuel:fuelTexture,
	Inventory.items.scrap:scrapTexture,
	Inventory.items.core:coreTexture,
}

#func getItemTexture(items)


signal playerInventoryUpdated
signal shipInventoryUpdated


func addItemsToPlayerInventory(items:Dictionary):
	for key in items.keys():
		if itemsInPlayerInventory >= Stats.inventorySlots:
			print("inventory - full, returning")
			return
		if playerInventory.has(key):
			playerInventory[key] += items[key]
			itemsInPlayerInventory + 1
		else:
			playerInventory[key] = items[key]
			itemsInPlayerInventory + 1
	playerInventoryUpdated.emit()



func _ready() -> void:
	if Globals.playerRef:
		newRunSetup()
	else:
		Globals.s_playerReady.connect(newRunSetup)


func newRunSetup():
	shipInventory = {}
	playerInventory = {}








#
