extends Node


var baseStats={
	"suit":{
		"current" : 100.0, # Basically health
		"max" : 100.0, # Basically health
		"maxBonusPercent": 0.0,
		"maxBonusFlat": 0,
		"generationRate" : 0.0, # higher is better
		"generationBonusPercent": 0.0,
		"inventorySlots" : 3,
		"inventorySlotsBonusFlat" : 0,
	},
	"energy":{
		"current" : 30.0,
		"max" : 30.0,
		"maxBonusPercent": 0.0,
		"maxBonusFlat": 0,
		"generationRate" : 0.0, # higher is better
		"generationBonusPercent": 0.0,
		"generationBonusFlat": 0,
	},
	"oxygen":{
		"current" : 10.0,
		"max" : 10.0,
		"maxBonusPercent": 0.0,
		"maxBonusFlat": 0,
		"generationEfficiency" : 1.0, # lower is better
		"generationRate" : 2.0, # higher is better
		"generationBonusPercent": 0.0,
		"generationBonusFlat": 0,
	},
	"weapon":{
		# current and max will be handled by the weapon itself
		"maxBonusPercent": 0.0,
		"maxBonusFlat": 0,
		"generationEfficiency" : 1.0, # lower is better
		"generationRate" : 1.0, # higher is better
		"generationBonusPercent": 0.0,
		#"generationBonusFlat": 0,
	},
	"equipment":{
		# current and max will be handled by the weapon itself
		"maxBonusPercent": 0.0,
		"maxBonusFlat": 0,
		"generationEfficiency" : 1.0, # lower is better
		"generationRate" : 1.0, # higher is better
		"generationBonusPercent": 0.0,
		#"generationBonusFlat": 0,
	},
}


var suit
var energy
var oxygen
var weapon
var equipment

func _ready() -> void:
	resetStats()

func functionalMax(key, obj=null): #
	if not obj:
		var total = $'.'[key].max + ($'.'[key].max * $'.'[key].maxBonusPercent)
		total += $'.'[key].maxBonusFlat
		return total
	else:
		var total = obj[key].max + (obj[key].max * $'.'[key].maxBonusPercent)
		total += $'.'[key].maxBonusFlat
		return total

func resetStats():
	for key in baseStats.keys():
		$'.'[key] = baseStats[key].duplicate()






enum trees {agility, looting, combat}

var upgrades = {
	"agility":{
		"1":{
			"cost":{Inventory.items.scrap:1},
			"stats":{"energyGeneration":0.2, "energyMax":10},
			"bought":false # Reset this on new run
		},
		"2":{
			"cost":{Inventory.items.scrap:2},
			"stats":{"energyGeneration":0.2},
			"bought":false
		},
		"3":{
			"cost":{Inventory.items.core:1},
			"stats":{"energyGeneration":0.2},
			"bought":false
		},
	},
	"looting":{
		"1":{
			"cost":{Inventory.items.scrap:1},
			"stats":{"inventorySlots":1, "oxygenMax":10},
			"bought":false # Reset this on new run
		},
		"2":{
			"cost":{Inventory.items.scrap:2},
			"stats":{"energyGeneration":0.2, "inventorySlots":1},
			"bought":false
		},
		"3":{
			"cost":{Inventory.items.core:1},
			"stats":{"laserGenerationRate":1, "inventorySlots":1},
			"bought":false
		},
	},
	"combat":{
		"1":{
			"cost":{Inventory.items.scrap:1},
			"stats":{"laserGenerationRate":0.1, "laserChargesMax":0.1},
			"bought":false # Reset this on new run
		},
		"2":{
			"cost":{Inventory.items.scrap:2},
			"stats":{"laserGenerationRate":0.25, "laserChargesMax":0.25},
			"bought":false
		},
		"3":{
			"cost":{Inventory.items.core:1},
			"stats":{"laserGenerationRate":0.34, "laserChargesMax":.34},
			"bought":false
		},
	},
}


func boughtUpgrade(branch, tier):
	print("stats - upgrading branch: ", branch, ", tier: ", tier)
	print("stats - upgrading stats: ", upgrades[branch][tier])
	print("stats - upgrading stats: ", upgrades[branch][tier]["stats"])
	for stat in upgrades[branch][tier]["stats"].keys():
		print("stats - upgrading stat: ", stat)
		$'.'[stat] += upgrades[branch][tier]["stats"][stat]
	upgrades[branch][tier]["bought"] = true
	print("stats - updated ", branch)














#
