extends Control



func _ready() -> void:
	Inventory.playerInventoryUpdated.connect(updatePlayerInventory)
	if Globals.playerRef:
		setup()
	else:
		Globals.s_playerReady.connect(setup)


func setupPlayerInventorySlots():
	Globals.playerRef

func updatePlayerInventory():
	var inventorySlots = %Inventory.get_children()
	var slot = 0
	for item in Inventory.playerInventory.keys():
		for i in Inventory.playerInventory[item]:
			if slot >= inventorySlots.size():
				return
			var iconNode = inventorySlots[slot].get_node("TextureRect")
			print("ui - icon node: ", iconNode, ", item: ", item, ", --", Inventory.playerInventory[item])
			iconNode.texture = Inventory.texMap[item]
			slot += 1




func _physics_process(delta: float) -> void:
	return
	if Globals.playerRef:
		%Energy.value = Stats.energy
		%Oxygen.value = Stats.oxygen
		trackLaserCharges()

func trackLaserCharges():
	#if Globals.playerRef.laserCharges > Globals.playerRef.laserChargesMax:
		#return
	#%Magazine.get_children()
	var i = 1
	for shell in %Magazine.get_children():
		#i += 1
		# something like shell recharge progress = Globals.playerRef.laserCharges % i   ???
		if Stats.laserCharges >= i:
			shell.visible = true
		else:
			shell.visible = false
		i += 1

func setup():
	return
	setEnergyBar()
	setOxygenBar()
	setMagazineBar()
	Globals.playerRef.updateInteractionPrompt.connect(updateInteractionPrompt)

func updateInteractionPrompt(newPrompt):
	if newPrompt == "":
		%InteractionPrompt.visible = false
	else:
		%InteractionPrompt.visible = true
		%InteractionPrompt.text = newPrompt

func setEnergyBar():
	%Energy.max_value = Stats.energyMax
	%Energy.value = Stats.energy

func setOxygenBar():
	%Oxygen.max_value = Stats.oxygenMax
	%Oxygen.value = Stats.oxygen

var standardShellSize = 20
func setMagazineBar():
	if Globals.playerRef:
		for c in %Magazine.get_children():
			c.queue_free()
		var verticalSize = %Magazine.get_parent_area_size().y
		var shellSize = standardShellSize
		if standardShellSize * Stats.laserChargesMax > verticalSize:
			shellSize = verticalSize / (Stats.laserChargesMax + 1)
		for s in Stats.laserChargesMax:
			var cRect = ColorRect.new()
			cRect.custom_minimum_size = Vector2(50, shellSize)
			cRect.color = Color(200,0,0)
			%Magazine.add_child(cRect)
		#print("ui - mag parent size", %Magazine.get_parent_area_size())



#
