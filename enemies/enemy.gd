extends CharacterBody2D

#region Exports
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

#endregion Exports


var health = 100.0
var dead = false

var canSeePlayer = false
var lockedOnToPlayer = false
var behavior = AI.Behaviors.BASIC
var intention = AI.Intentions.WANDER




func _physics_process(delta):
	if dead or not Globals.playerRef:
		return
	canSeePlayer = _canSeePlayer()
	if canSeePlayer:
		print("enemy - can see player")
	AI.act(delta, $'.', behavior)
	#if not is_on_floor():
		#velocity.y += _get_gravity(velocity) * delta
		#_get_movement(air_resistance, air_acceleration, delta)
	#else:
		#_get_movement(friction, acceleration, delta)
	#_set_sprite_direction(sign(velocity.x))
	#move_and_slide()




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
	if has_node("RayCast2D"):
		var ray = $RayCast2D
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
