extends Node2D


@export var chargedColor = Color.GREEN
@export var unchargedColor = Color.RED
@export var chargingColor = Color.PURPLE
@export var tiltAmount:float = 0.2

var meterSize
var isChargingColor = false


func setup(meterSize:Vector2, maxAmmo):
	for c in $'.'.get_children():
		c.queue_free()
	$'.'.meterSize = meterSize
	var ammoBarSize = Vector2(meterSize.x / maxAmmo, meterSize.y)
	for i in maxAmmo:
		var p = makeAmmoPolygon(ammoBarSize)
		p.position.x = ammoBarSize.x * i
		$'.'.add_child(p)

func makeAmmoPolygon(barSize):
	var p = Polygon2D.new()
	#p.color = Color.RED
	p.color = Color.GREEN
	var points = [Vector2(0, 0), Vector2(barSize.x, 0), barSize, Vector2(0, barSize.y)]
	p.polygon = points
	return p


func toggleChargingColorOnLast(currentAmmo):
	var ammoNodes = $'.'.get_children()
	#print("ammo meter - ammo nodes: ", ammoNodes)
	if isChargingColor:
		ammoNodes[currentAmmo].color = chargingColor
	else:
		ammoNodes[currentAmmo].color = unchargedColor
	isChargingColor = ! isChargingColor


func updateAmmoCount(newTotal:int):
	var count = 0
	for c in $'.'.get_children():
		count += 1
		if count > newTotal:
			#c.visible = false
			c.color = Color.RED
		else:
			#c.visible = true
			c.color = Color.GREEN


func changeMeterColor(newColor:Color):
	for c in $'.'.get_children():
		if "color" in c:
			c.color = newColor








#
