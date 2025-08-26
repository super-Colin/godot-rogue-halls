extends Control


var shaderSettings = {}




func freeUndisplayedPlanets(destinationType):
	if destinationType == Globals.DestinationTypes.BLACKHOLE:
		$GasPlanet.free()
		$Galaxy.free()
		$Terran.free()
		$Star.free()
	elif destinationType == Globals.DestinationTypes.GALAXY:
		$GasPlanet.free()
		$BlackHole.free()
		$Terran.free()
		$Star.free()
	elif destinationType == Globals.DestinationTypes.GAS_PLANET:
		$Galaxy.free()
		$BlackHole.free()
		$Terran.free()
		$Star.free()
	elif destinationType == Globals.DestinationTypes.TERRAN:
		$GasPlanet.free()
		$Galaxy.free()
		$BlackHole.free()
		$Star.free()
	elif destinationType == Globals.DestinationTypes.STAR:
		$GasPlanet.free()
		$Galaxy.free()
		$Terran.free()
		$BlackHole.free()
	adjustRootMinSize()
	#await get_tree().process_frame
	#randomizeColors()





func randomizeColors():
	$'.'.get_children()[0].randomize_colors()
func getColors():
	return $'.'.get_children()[0].get_colors()
func setColors(colors):
	print("dest sprite - setting colors")
	return $'.'.get_children()[0].set_colors(colors)

func adjustRootMinSize():
	var childSprite = $'.'.get_children()[0]
	if childSprite.name == "BlackHole":
		$'.'.size = $BlackHole.size
		#$'.'.position = $BlackHole.position
	elif childSprite.name == "Galaxy":
		$'.'.size = $Galaxy.size
		#$'.'.position = $Galaxy.position
	elif childSprite.name == "GasPlanet":
		$'.'.size = $GasPlanet.size
		#$'.'.position = $GasPlanet.position
	elif childSprite.name == "Terran":
		$'.'.size = $Terran.size
		#$'.'.position = $Terran.position
	elif childSprite.name == "Star":
		$'.'.size = $Star.size
		#$'.'.position = $Star.position





#
