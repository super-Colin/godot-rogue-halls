extends Control






func _ready() -> void:
	%StartLevelButton.pressed.connect(func():Globals.s_startLevel.emit())
	#updateInventoryDisplay()



func setupUpgradeTree():
	updateInventoryDisplay()
	for skill in Stats.trees:
		print("ship menu - skill: ", skill, ", upgrades: ", Stats.upgrades[skill])
		setupSkillBranch(skill)
		#if skill == Stats.trees.agility:
			#


func updateInventoryDisplay():
	%FuelInventory/Label.text = str(Inventory.shipInventory[Inventory.items.fuel])
	%ScrapInventory/Label.text = str(Inventory.shipInventory[Inventory.items.scrap])
	%CoreInventory/Label.text = str(Inventory.shipInventory[Inventory.items.core])

func setupSkillBranch(skillBranch):
	var parentNode
	if skillBranch == "agility":
		parentNode = %AgilityTree
	elif skillBranch == "looting":
		parentNode = %LootingTree
	elif skillBranch == "combat":
		parentNode = %CombatTree
	var highestTierBought = 0
	for tier in Stats.upgrades[skillBranch]:
		print("ship menu - tier: ", tier, ", cost: ", Stats.upgrades[skillBranch][tier]["cost"])
		var button = parentNode.get_node("Level"+ str(tier) +"/Button")
		if button.pressed.is_connected(buySkillUpgrade):
			button.pressed.disconnect(buySkillUpgrade)
		if Stats.upgrades[skillBranch][tier]["bought"]:
			markButtonAsBought(button)
			highestTierBought = str_to_var(tier)
			continue
		var canAfford = Inventory.canShipAffordCost(Stats.upgrades[skillBranch][tier]["cost"])
		if canAfford and highestTierBought == str_to_var(tier)-1:
		#if canAfford:
			markButtonAsCanAfford(button)
			button.pressed.connect(buySkillUpgrade.bind(skillBranch, tier))
		else:
			markButtonAsCantAfford(button)

func buySkillUpgrade(branch, tier):
	print("ship - bought upgrade: ", branch, ": ", tier)
	Inventory.payCostFromShipInventory(Stats.upgrades[branch][tier]["cost"])
	Stats.boughtUpgrade(branch, tier)
	#setupSkillBranch(branch)
	setupUpgradeTree()



func markButtonAsCanAfford(button):
	button.disabled = false

func markButtonAsBought(button):
	var styleBox = StyleBoxFlat.new()
	styleBox.bg_color = Color(0,200,0)
	button.add_theme_stylebox_override("disabled", styleBox)
	button.disabled = true

func markButtonAsCantAfford(button):
	var styleBox = StyleBoxFlat.new()
	styleBox.bg_color = Color(200,0,0)
	button.add_theme_stylebox_override("disabled", styleBox)
	button.disabled = true



func setupNavigationTree():
	pass

# Utilities.generateMapSeed..??












#
