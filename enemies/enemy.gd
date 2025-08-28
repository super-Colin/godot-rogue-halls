extends CharacterBody2D

#region Exports
@export_group("Behavior")
@export var defualtBehavior:AI.Behaviors = AI.Behaviors.BASIC
@export var enabledBehaviors:Array[AI.Behaviors] = [AI.Behaviors.BASIC]


@export_group("Hunting")
@export var fov_distance = 1200.0
@export var fov_angle = 60.0 # Degrees, half on each side


@export_group("Movement")
## Maximum speed reachable by player
@export_range(0, 500) var max_speed = 200.0
## Minimum speed when variable_min_speed is set to true & min_speed isn't 0
@export_range(0, 500) var min_speed = 0.0
## Acceleration while on the ground (how quickly the player reaches max speed)
@export_range(0, 500) var acceleration = 100.0
## Friction while on group (how quickly the player slows down)
@export_range(0, 50) var friction = 50.0
## Acceleration while in the air (how quickly the player reaches max speed)
@export_range(0, 500) var air_acceleration = 5.0
## Air friction while in the air (how quickly the player slows down)
@export_range(0, 50) var air_resistance = 50.0


@export_group("Jump")
@export var can_jump = false
## Max jump height
@export var jump_height = 100
## Amount of time it takes the player to reach the peak of their jump
@export var jump_time_to_peak = 0.4
## Amount of time it takes the player to fall from the peak of their jump to the ground
@export var jump_time_to_descent = 0.3
## Determains if a player jump highet changes depending on how long they held it in
@export var variable_jump_height = false
## Determains the minumum jump heighet a player can reach if they barely tap the jump button (and variable_jump_height is true)
@export var minimum_jump_height = -100


@onready var jump_velocity : float = (2.0 * jump_height) / jump_time_to_peak * -1
@onready var jump_gravity : float = (-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak) * -1
@onready var fall_gravity : float = (-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent) * -1

@onready var currentBehavior = defualtBehavior

#endregion Exports


var health = 100.0
var dead = false

var canSeePlayer = false
var lockedOnToPlayer = false

var intention = AI.Intentions.WANDER
@onready var behavior = defualtBehavior
@onready var currentTargetPoint = $LineOfSight.target_position









func _physics_process(delta):
	apply_gravity(delta)
	if dead or not Globals.playerRef:
		move_and_slide()
		return
	#moveFoward(delta)
	chooseAction(delta)
	move_and_slide()
	return
	#apply_gravity(delta)
	#canSeePlayer = _canSeePlayer()
	#chooseAction(delta)
	#return
	#if canSeePlayer:
		#print("enemy - can see player")
	
	
	#AI.createIntention($'.', currentBehavior)
	#if not is_on_floor():
		#velocity.y += _get_gravity(velocity) * delta
		#_get_movement(air_resistance, air_acceleration, delta)
	#else:
		#_get_movement(friction, acceleration, delta)
	

	#AI.act(delta, $'.', behavior)
	#if not is_on_floor():
		#velocity.y += _get_gravity(velocity) * delta
		#_get_movement(air_resistance, air_acceleration, delta)
	#else:
		#_get_movement(friction, acceleration, delta)
	#_set_sprite_direction(sign(velocity.x))
	#move_and_slide()




func moveFoward(delta):
	var direction = getFacingDirection()
	#print("enemy - direction is: ", direction)
	var walkingInfluence
	var accel = acceleration
	var fric = friction
	if not is_on_floor():
		accel = air_acceleration
		fric = air_resistance
	if direction:
		walkingInfluence = sign(direction.x) * accel * delta * 100
		if (not velocity.x < -max_speed and not velocity.x > max_speed):
			velocity.x += walkingInfluence
		else:
			#print("enemy - too fast.. velocity: ", velocity)
			velocity.x = move_toward(velocity.x, max_speed, fric * delta * 100)
		print("enemy - walkingInfluence: ", walkingInfluence)
	else:
		#print("enemy - no direction: ", direction)
		velocity.x = move_toward(velocity.x, 0, fric * delta * 100)
	#_set_sprite_direction(sign(vertlocity.x))




func apply_gravity(delta):
	var gravVector = get_gravity()
	velocity += gravVector * delta
	if velocity.y < -max_speed:
		print("enemy - apply_gravity velocity: ", velocity)
		velocity.y = move_toward(velocity.y, -max_speed, air_resistance * delta * 100)













func chooseAction(delta):
	match behavior:
		AI.Behaviors.BASIC:
			#if enemyNodeRef.canSeePlayer:
			intention = AI.Intentions.WANDER
		AI.Behaviors.SWEEP:
			intention = AI.Intentions.MOVE_TOWARD
			#createNewTargetPoint()
			_sweep(delta)
			return
	match intention:
		AI.Intentions.WANDER:
			_wander(delta)
		#AI.Intentions.PATROL:
			#_patrol()
		AI.Intentions.SEEK:
			_seek()
		AI.Intentions.CHASE:
			_chase()

#
#func createNewTargetPoint(newPoint=null):
	#if not newPoint: # for the wandering mode
		#currentTargetPoint = Vector2()










func _canSeePlayer() -> bool:
	#if not Globals.playerRef or not is_instance_valid(Globals.playerRef):
	if not Globals.playerRef:
		return false
	var to_player = Globals.playerRef.global_position - global_position
	var distance = to_player.length()
	if distance > fov_distance:
		return false
	# Check angle between enemy's "facing direction" and the vector to the player
	var facing_dir = Vector2.RIGHT if not $Sprite.flip_h else Vector2.LEFT
	var angle = rad_to_deg(facing_dir.angle_to(to_player.normalized()))
	if abs(angle) > fov_angle / 2.0:
		return false
	# Line-of-sight check using RayCast2D
	if has_node("LineOfSight"):
		var ray = $LineOfSight
		ray.target_position = to_player
		ray.force_raycast_update()
		if ray.is_colliding():
			var collider = ray.get_collider()
			if collider == Globals.playerRef:
				return true
			else:
				return false
		else:
			return true
	return false






func isCloseToWall():
	if $WallCheck.is_colliding():
		print("enemy - hit wall")
		return true
	return false

func isCloseToLedge():
	if not $LedgeCheck.is_colliding():
		print("enemy - on ledge")
		return true
	return false



func _sweep(delta):
	#print("enemy - sweeping")
	#if isCloseToWall() or isCloseToLedge():
	if isCloseToWall():
		print("enemy - turning around because close to wall or ledge")
		turnAround()
		var sign = sign(getFacingDirection().x)
		#currentTargetPoint = Vector2(-sign * fov_distance, 0) # turn around
	#velocity.x = lerp(velocity.x, randf_range(-1, 1) * acceleration, delta)
	#moveTowardTargetPoint(delta)
	moveFoward(delta)


func turnAround():
	#print("enemy - turning around")
	if getFacingDirection() == Vector2.RIGHT:
		turnLeft()
	else:
		turnRight()


func turnRight():
	$Sprite.flip_h = false
	$WallCheck.target_position.x = abs($WallCheck.target_position.x)
	$LedgeCheck.target_position.x = abs($LedgeCheck.target_position.x)
	$LineOfSight.target_position.x = abs($LineOfSight.target_position.x)
	#$LineOfSight.position.x = abs($LineOfSight.position.x)
	#currentTargetPoint.x = fov_distance, 0
	currentTargetPoint = Vector2(fov_distance, 0)

func turnLeft():
	$Sprite.flip_h = true
	$WallCheck.target_position.x = -abs($WallCheck.target_position.x)
	$LedgeCheck.target_position.x = -abs($LedgeCheck.target_position.x)
	$LineOfSight.target_position.x = -abs($LineOfSight.target_position.x)
	#$LineOfSight.position.x = -abs($LineOfSight.position.x)
	currentTargetPoint = Vector2(-fov_distance, 0)
	#currentTargetPoint.x = -fov_distance




func getFacingDirection()->Vector2:
	return Vector2.RIGHT if not $Sprite.flip_h else Vector2.LEFT

func _wander(delta):
	#velocity.x = lerp(velocity.x, randf_range(-1, 1) * acceleration, 0.05)
	#_get_movement(air_resistance, air_acceleration, delta)
	velocity.x = lerp(velocity.x, randf_range(-1, 1) * acceleration, delta)

#func _patrol():
	#if position.x < patrol_start:
		#moving_right = true
	#elif position.x > patrol_end:
		#moving_right = false
	#velocity.x = speed if moving_right else -speed

func _seek():
	if Globals.playerRef:
		var direction = sign(Globals.playerRef.global_position.x - global_position.x)
		velocity.x = direction * acceleration

func _chase():
	if Globals.playerRef:
		var distance = global_position.distance_to(Globals.playerRef.global_position)
		if distance < 300:
			var direction = sign(Globals.playerRef.global_position.x - global_position.x)
			velocity.x = direction * (acceleration * 1.5)









# Sets the gravity depending on the context
func _get_gravity(_velocity):
	return jump_gravity if _velocity.y < 0.0 else fall_gravity









func moveTowardTargetPoint(delta):
	if not currentTargetPoint:
		return
	var direction = currentTargetPoint.global_position - global_position
	var walkingInfluence
	var accel = acceleration
	var fric = friction
	if not is_on_floor():
		accel = air_acceleration
		fric = air_resistance
	if direction:
		walkingInfluence = sign(direction) * accel * delta * 100
		if (not velocity.x < -max_speed and not velocity.x > max_speed):
			velocity.x += walkingInfluence
		else:
			velocity.x = move_toward(velocity.x, max_speed, fric * delta * 100)
	else:
		velocity.x = move_toward(velocity.x, 0, fric * delta * 100)
	_set_sprite_direction(sign(velocity.x))


func walkForward(fric: float, accel: float, delta: float):
	return




func _get_movement(fric: float, accel: float, delta: float):
	var direction = (Globals.playerRef.global_position.x - $'.'.global_position.x )
	if direction:
		velocity.x += sign(direction) * accel * delta * 100
	if !direction or sign(direction) != sign(velocity.x):
		velocity.x = move_toward(velocity.x, 0, fric * delta * 100)
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	
	#if is_variable_min_speed and min_speed > 0:
			#velocity.x = maxf(abs(velocity.x), abs(min_speed * sign(direction))) * sign(direction)




# Adds the player's jump velocity if able
func jump():
	velocity.y = jump_velocity



# Stops jump acceleration if variable_jump_height is enabled
func jump_cut():
	if not variable_jump_height:
		return
	if velocity.y < minimum_jump_height * up_direction.y:
		velocity.y = minimum_jump_height * up_direction.y




func _set_sprite_direction(direction: int) -> void:
	if direction > 0.0:
		$Sprite.flip_h = true
	elif direction < 0.0:
		$Sprite.flip_h = false
		




func _draw():
	draw_arc(Vector2.ZERO, fov_distance, deg_to_rad(-fov_angle / 2), deg_to_rad(fov_angle), 32, Color.RED)





func hitByLaser(laser):
	takeDamage(laser.damage)

func takeDamage(amount):
	health -= amount
	if health <= 0:
		#$'.'.queue_free()
		dead = true



#
