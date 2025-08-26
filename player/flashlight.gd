extends RigidBody2D
#extends CharacterBody2D
#
#const MAX_ROTATION = deg_to_rad(45)  # Right limit
#const MIN_ROTATION = deg_to_rad(-45) # Left limit
#const TORQUE_STRENGTH = 300.0
#
#func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	#influenceFlashlightTorque(state)
#
#func influenceFlashlightTorque(state: PhysicsDirectBodyState2D):
	#var angle = state.transform.get_rotation()
#
	## Clamp the rotation
	#angle = clamp(angle, MIN_ROTATION, MAX_ROTATION)
#
	## Stop spinning if at limit and still trying to go past it
	#if (angle >= MAX_ROTATION and state.angular_velocity > 0) or \
		#(angle <= MIN_ROTATION and state.angular_velocity < 0):
		#state.angular_velocity = 0
#
	## Forcefully set the clamped rotation
	##var xform = state.transform
	##xform.set_rotation(angle)
	##state.transform = xform
