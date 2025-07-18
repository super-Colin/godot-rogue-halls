extends Control







func freeUndisplayedPlanets(destinationType):
	if destinationType == Globals.DestinationTypes.BLACKHOLE:
		$GasPlanet.queue_free()
		$Galaxy.queue_free()
		$Terran.queue_free()
		$Star.queue_free()
	elif destinationType == Globals.DestinationTypes.GALAXY:
		$GasPlanet.queue_free()
		$BlackHole.queue_free()
		$Terran.queue_free()
		$Star.queue_free()
	elif destinationType == Globals.DestinationTypes.GAS_PLANET:
		$Galaxy.queue_free()
		$BlackHole.queue_free()
		$Terran.queue_free()
		$Star.queue_free()
	elif destinationType == Globals.DestinationTypes.TERRAN:
		$GasPlanet.queue_free()
		$Galaxy.queue_free()
		$BlackHole.queue_free()
		$Star.queue_free()
	elif destinationType == Globals.DestinationTypes.STAR:
		$GasPlanet.queue_free()
		$Galaxy.queue_free()
		$Terran.queue_free()
		$BlackHole.queue_free()
	adjustRootMinSize()



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
