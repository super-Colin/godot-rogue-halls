extends RigidBody2D

enum AmmoTypes {LASER, BULLET, MISSLE}

@export var ammoType = AmmoTypes.LASER


var laserProjectileScene = preload("res://laser_projectile.tscn")






func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# hand correcting gun rotation
	state.angular_velocity = -$'.'.rotation * 10
	# Recoil
	if firedLaser:
		#print("gun - laser parent rotation: ", $'.'.get_parent().rotation)
		var sign = sign(abs($'.'.get_parent().rotation) - PI/2)
		$'.'.apply_torque_impulse(100000 * sign)
		firedLaser = false




var firedLaser = false
func fireLaser():
	#print("gun - firing laser")
	var las = laserProjectileScene.instantiate()
	las.position = $'.'.global_position
	las.rotation = $'.'.global_rotation
	get_tree().root.add_child(las)
	firedLaser = true
	#$'.'.apply_torque(10000)


#func _physics_process(delta: float) -> void:
	#if firedLaser:
		#$'.'.apply_torque(10000)
		#firedLaser = false
