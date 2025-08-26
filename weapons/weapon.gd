extends RigidBody2D

enum AmmoTypes {LASER, BULLET, MISSLE}

@export var ammoType = AmmoTypes.LASER


var laserProjectileScene = preload("res://weapons/laser_projectile.tscn")

#var baseStats= {
	#"weapon":{
		#"current" : 3.0,
		#"max" : 3.0,
		#"generationRate" : 1.0, # higher is better
	#},
#}

@export var maxAmmo = 3.0
@export var energyPerAmmo = 1.0 # per second
@export var generationRate = 0.34 # per second

var currentAmmo = 3.0
var generationBonusPercent = 0.0
var chargeBlinkingTimer = 0.0


#func _process(delta: float) -> void:
	#if currentAmmo != maxAmmo:
		#chargeBlinkingTimer += delta
		##if chargeBlinkingTimer >= generationRate / 2:
		#if chargeBlinkingTimer >= generationRate:
			#$AmmoMeter.toggleChargingColorOnLast(floori(currentAmmo))
			#chargeBlinkingTimer = 0.0


func setupWeapon(maxAmmoBonusPercent:float=0.0, maxAmmoBonusFlat:int=0, bonusGenerationRate:float=0.0):
	maxAmmo += maxAmmo * maxAmmoBonusPercent
	maxAmmo += maxAmmoBonusFlat
	currentAmmo = maxAmmo
	generationBonusPercent = bonusGenerationRate
	$AmmoMeter.setup(($AmmoMeterMarker2.position - $AmmoMeterMarker1.position), maxAmmo)

func getGenerationEnergyCost(delta)->float:
	if currentAmmo == maxAmmo:
		return 0.0
	return generationAmount(delta) * energyPerAmmo

func generateAmmo(delta):
	if currentAmmo == maxAmmo:
		return
	#print("weapon - generating ammo")
	var oldAmmoCount = currentAmmo
	currentAmmo = clamp(currentAmmo + generationAmount(delta), 0, maxAmmo)
	if floori(oldAmmoCount) != floori(currentAmmo):
		$AmmoMeter.updateAmmoCount(currentAmmo)
	if currentAmmo != maxAmmo:
		chargeBlinkingTimer += delta
		if chargeBlinkingTimer >= generationRate / 2:
		#if chargeBlinkingTimer >= generationRate:
			$AmmoMeter.toggleChargingColorOnLast(floori(currentAmmo))
			chargeBlinkingTimer = 0.0

func generationAmount(delta)->float:
	return (generationRate + (generationRate * generationBonusPercent)) * delta

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# hand correcting gun rotation
	state.angular_velocity = -$'.'.rotation * 10
	# Recoil
	if firedWeapon:
		#print("gun - laser parent rotation: ", $'.'.get_parent().rotation)
		var sign = sign(abs($'.'.get_parent().rotation) - PI/2)
		$'.'.apply_torque_impulse(100000 * sign)
		firedWeapon = false




var firedWeapon = false
func fireWeapon()->bool:
	if not currentAmmo >= 1.0:
		return false
	currentAmmo -= 1.0
	#print("gun - firing laser")
	var las = laserProjectileScene.instantiate()
	las.position = $'.'.global_position
	las.rotation = $'.'.global_rotation
	get_tree().root.add_child(las)
	firedWeapon = true
	#$'.'.apply_torque(10000)
	$AmmoMeter.updateAmmoCount(currentAmmo)
	return true


#func _physics_process(delta: float) -> void:
	#if firedLaser:
		#$'.'.apply_torque(10000)
		#firedLaser = false
