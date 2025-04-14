extends Control



func _ready() -> void:
	if Globals.playerRef:
		setup()
	else:
		Globals.s_playerReady.connect(setup)

func _physics_process(delta: float) -> void:
	if Globals.playerRef:
		%Energy.value = Globals.playerRef.energy
		%Oxygen.value = Globals.playerRef.oxygen
		trackLaserCharges()

func trackLaserCharges():
	#if Globals.playerRef.laserCharges > Globals.playerRef.laserChargesMax:
		#return
	#%Magazine.get_children()
	var i = 1
	for shell in %Magazine.get_children():
		#i += 1
		if Globals.playerRef.laserCharges >= i:
			shell.visible = true
		else:
			shell.visible = false
		i += 1

func setup():
	setEnergyBar()
	setOxygenBar()
	setMagazineBar()

func setEnergyBar():
	%Energy.max_value = Globals.playerRef.energyMax
	%Energy.value = Globals.playerRef.energy

func setOxygenBar():
	%Oxygen.max_value = Globals.playerRef.oxygenMax
	%Oxygen.value = Globals.playerRef.oxygen

var standardShellSize = 20
func setMagazineBar():
	if Globals.playerRef:
		for c in %Magazine.get_children():
			c.queue_free()
		var verticalSize = %Magazine.get_parent_area_size().y
		var shellSize = standardShellSize
		if standardShellSize * Globals.playerRef.laserChargesMax > verticalSize:
			shellSize = verticalSize / (Globals.playerRef.laserChargesMax + 1)
		for s in Globals.playerRef.laserChargesMax:
			var cRect = ColorRect.new()
			cRect.custom_minimum_size = Vector2(50, shellSize)
			cRect.color = Color(200,0,0)
			%Magazine.add_child(cRect)
		#print("ui - mag parent size", %Magazine.get_parent_area_size())



#
