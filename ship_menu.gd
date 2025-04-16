extends Control






func _ready() -> void:
	%StartLevelButton.pressed.connect(func():Globals.s_startLevel.emit())
	pass



func setupUpgradeTree():
	for skill in Stats.trees:
		print("ship menu - skill: ", skill, ", upgrades: ", Stats.upgrades[skill])
		setupSkillBranch(skill)
		#if skill == Stats.trees.agility:
			#



func setupSkillBranch(skillBranch):
	var parentNode
	#if skillBranch == Stats.trees.agility:
	if skillBranch == "agility":
		print("is agility tree")
		parentNode = %AgilityTree
	else:
		return
	var highestTierBought = 0
	for tier in Stats.upgrades[skillBranch]:
		print("ship menu - tier: ", tier, ", cost: ", Stats.upgrades[skillBranch][tier]["cost"])
		if Stats.upgrades[skillBranch][tier]["bought"]:
			parentNode.get_node("Level"+ str(tier) +"/Button").disabled = true
			highestTierBought = tier
			continue
		var canAfford = Inventory.canShipAffordCost(Stats.upgrades[skillBranch][tier]["cost"])
		#if canAfford and not b
		if canAfford:
			parentNode.get_node("Level"+ str(tier) +"/Button").disabled = false
			parentNode.get_node("Level"+ str(tier) +"/Button").pressed.connect(buySkillUpgrade.bind(skillBranch, tier))
		else:
			parentNode.get_node("Level"+ str(tier) +"/Button").disabled = true

func buySkillUpgrade(branch, tier):
	print("ship - bought upgrade: ", branch, ": ", tier)
	Inventory.payCostFromShipInventory(Stats.upgrades[branch][tier]["cost"])
	Stats.boughtUpgrade(branch, tier)



func setupNavigationTree():
	pass

# Utilities.generateMapSeed..??












#
