extends CharacterBody2D

#region Exports
@export_group("Movement")
## Maximum speed reachable by player
@export_range(0, 500) var max_speed := 200.0
## Minimum speed when variable_min_speed is set to true & min_speed isn't 0
@export_range(0, 500) var min_speed := 0.0
## Acceleration while on the ground (how quickly the player reaches max speed)
@export_range(0, 500) var acceleration := 100.0
## Friction while on group (how quickly the player slows down)
@export_range(0, 50) var friction := 50.0
## Acceleration while in the air (how quickly the player reaches max speed)
@export_range(0, 500) var air_acceleration := 5.0
## Air friction while in the air (how quickly the player slows down)
@export_range(0, 50) var air_resistance := 50.0


@export_group("Jump")
## Max jump height
@export var jump_height := 100
## Amount of time it takes the player to reach the peak of their jump
@export var jump_time_to_peak := 0.4
## Amount of time it takes the player to fall from the peak of their jump to the ground
@export var jump_time_to_descent := 0.3
## Determains if a player jump highet changes depending on how long they held it in
@export var variable_jump_height := false
## Determains the minumum jump heighet a player can reach if they barely tap the jump button (and variable_jump_height is true)
@export var minimum_jump_height := -100


@onready var jump_velocity : float = (2.0 * jump_height) / jump_time_to_peak * -1
@onready var jump_gravity : float = (-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak) * -1
@onready var fall_gravity : float = (-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent) * -1

#endregion Exports

var health = 100.0
var dead = false

var lockedOnToPlayer = false
var behavior = AI.Behaviors.BASIC
var intention = AI.Intentions.WANDER


func hitByLaser(laser):
	takeDamage(laser.damage)

func takeDamage(amount):
	health -= amount
	if health <= 0:
		$'.'.queue_free()


func _physics_process(delta):
	if dead or not Globals.playerInLevel:
		return
	#AI.attackPlayer($'.')
	AI.act(delta, $'.', behavior)
	#if not is_on_floor():
		#velocity.y += _get_gravity(velocity) * delta
		#_get_movement(air_resistance, air_acceleration, delta)
	#else:
		#_get_movement(friction, acceleration, delta)
	#_set_sprite_direction(sign(velocity.x))
	##if Input.is_action_just_pressed("Jump"):
		##jump()
	#if Input.is_action_just_released("Jump"):
		#jump_cut()
	#move_and_slide()


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
	#if coyote_timer.time_left > 0.0:
		#coyote_timer.stop()
	velocity.y = jump_velocity
	
	#if _get_gravity(velocity) == fall_gravity:
		#jump_buffer_timer.start()


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
		
