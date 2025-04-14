extends Node


var shipInventory = {}
var playerInventory = {}


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


func addItemsToPlayerInventory(items:Dictionary):
	for key in items.keys():
		if playerInventory.has(key):
			playerInventory[key] += items[key]
		else:
			playerInventory[key] = items[key]
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
