extends Node


var baseStats={
	laserChargesMax : 3.0,
	#laserCharges : 3.0,
	laserGenerationEnergyEfficiency : 1.0, # lower is better
	laserGenerationRate : 0.2, # higher is better
	#laserRegenerationOn : true,

	energyMax : 30.0,
	#energy : 30.0,
	energyGeneration : 0.0,

	oxygenMax : 30.0,
	#oxygen : 30.0,
	oxygenGenerationEnergyEfficiency : 1.0, # lower is better
	oxygenGenerationRate : 2.0, # higher is better

	#suitConditionMax : 100.0,
	#suitCondition : 100.0,
	inventorySlots : 3,
}
func resetStats():
	for key in baseStats.keys():
		$'.'[key] = baseStats[key]


var laserChargesMax = 3.0
var laserCharges = 3.0
var laserGenerationEnergyEfficiency = 1.0 # lower is better
var laserGenerationRate = 0.2 # higher is better
var laserRegenerationOn = true

var energyMax = 30.0
var energy = 30.0
var energyGeneration = 0.0

var oxygenMax = 30.0
var oxygen = 30.0
var oxygenGenerationEnergyEfficiency = 1.0 # lower is better
var oxygenGenerationRate = 2.0 # higher is better

var suitConditionMax = 100.0
var suitCondition = 100.0

var inventorySlots = 3

## RPG style skills, level with exp
#var speed = 3.0
#var strength = 3.0
#var shooting = 3.0



enum trees {agility, looting, combat}

var upgrades = {
	"agility":{
		"1":{
			"cost":{Inventory.items.scrap:1},
			"stats":{"energyMax":20},
			"bought":false # Reset this on new run
		},
		"2":{
			"cost":{Inventory.items.scrap:2},
			"stats":{"energyGeneration":2},
			"bought":false
		},
		"3":{
			"cost":{Inventory.items.core:1},
			"stats":{"laserGenerationRate":5},
			"bought":false
		},
	},
	"looting":{},
	"combat":{},
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
