extends Node



enum Behaviors {BASIC}

enum Intentions {WANDER, PATROL, SEEK, CHASE, }







func createIntention(enemyNodeRef, behavior):
	match behavior:
		Behaviors.BASIC:
			enemyNodeRef.intention = Intentions.WANDER
	print("AI - creating intention")


func act(delta, enemyNodeRef, behavior = Behaviors.BASIC):
	#if behavior == Behaviors.BASIC:
	if not enemyNodeRef.is_on_floor():
		enemyNodeRef.velocity.y += enemyNodeRef._get_gravity(enemyNodeRef.velocity) * delta
		#enemyNodeRef._get_movement(enemyNodeRef.air_resistance, enemyNodeRef.air_acceleration, delta)
	else:
		enemyNodeRef._get_movement(enemyNodeRef.friction, enemyNodeRef.acceleration, delta)
	enemyNodeRef._set_sprite_direction(sign(enemyNodeRef.velocity.x))
	match enemyNodeRef.intention:
		Intentions.WANDER:
			enemyNodeRef._wander(delta)
		Intentions.PATROL:
			enemyNodeRef._patrol()
		Intentions.SEEK:
			enemyNodeRef._seek()
		Intentions.CHASE:
			enemyNodeRef._chase()
	enemyNodeRef.move_and_slide()


#func wander(delta, enemyNodeRef):
	#enemyNodeRef.moveTowardTarget()
	#enemyNodeRef.velocity.x = lerp(enemyNodeRef.velocity.x, randf_range(-1, 1) * enemyNodeRef.acceleration, 0.1)













func directionToPlayer(aiNode:CharacterBody2D):
	return (Globals.playerRef.global_position - aiNode.global_position)

func attackPlayer(aiNode:CharacterBody2D):
	var direction = directionToPlayer(aiNode)












#
