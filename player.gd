class_name Player
extends CharacterBody2D

var laserProjectileScene = preload("res://laser_projectile.tscn")




@onready var coyote_timer = $CoyoteTimer
@onready var jump_buffer_timer = $JumpBufferTimer
#@onready var jump_trojectory_line = $JumpTrojectoryLine


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
## Sets a variable max speed depending on how far the joystick is pushed
@export var is_variable_max_speed := false
## sets a minimum speed based on min_speed
@export var is_variable_min_speed := false

@export_group("Jump Assist")
## Max amount of time allowed after leaving the ground while still being able to jump
@export_range(0, 1) var coyote_timer_value = 0.1
## Max amount of time the game holds on to the players input to accecute when avaiable
@export_range(0, 1) var jump_buffer_timer_value = 0.15


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

@export_group("Jump Trojectory")
## Maximum amount of points used to visualize player's jump trojectory (WiP)
@export var max_trojectory_ponints := 100


@onready var jump_velocity : float = (2.0 * jump_height) / jump_time_to_peak * -1
@onready var jump_gravity : float = (-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak) * -1
@onready var fall_gravity : float = (-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent) * -1


var dead = false

var laserChargesMax = 3.0
var laserCharges = 3.0
var laserGenerationEnergyEfficiency = 1.0 # lower is better
var laserGenerationRate = 0.2 # higher is better
var laserRegenerationOn = true

var energyMax = 30.0
var energy = 30.0
var energyGeneration = 0.0

var oxygenMax = 30.0
var oxygen = 30.0
var oxygenGenerationEnergyEfficiency = 1.0 # lower is better
var oxygenGenerationRate = 2.0 # higher is better

var suitCondition = 100.0


var currentInteractionObject:Node






func fireLaser():
	print("player - firing laser, charges left: ", laserCharges)
	if laserCharges < 1:
		return
	laserCharges -= 1
	var las = laserProjectileScene.instantiate()
	las.position = $'.'.global_position
	get_tree().root.add_child(las)




func _ready():
	Globals.playerRef = $'.'
	Globals.s_playerReady.emit()
	%PickupRange.area_entered.connect(checkForPromptUpdate.bind(true))
	%PickupRange.area_exited.connect(checkForPromptUpdate.bind(false))
	%PickupRange.body_entered.connect(checkForPromptUpdate.bind(true))
	%PickupRange.body_exited.connect(checkForPromptUpdate.bind(false))
	#coyote_timer.wait_time = coyote_timer_value
	#jump_buffer_timer.wait_time = jump_buffer_timer_value




signal updateInteractionPrompt(string)

func checkForPromptUpdate(areaOrBody:Node, entered:bool): # entered or exited
	if not "playerInteraction" in areaOrBody:
		return
	if entered:
		print("player: object is usable: ", areaOrBody)
		currentInteractionObject = areaOrBody
		updateInteractionPrompt.emit(currentInteractionObject.interactionPrompt)
	elif areaOrBody == currentInteractionObject and not entered:
		updateInteractionPrompt.emit("")

func clearInteractionOject():
	updateInteractionPrompt.emit("")
	currentInteractionObject = null

func rechargeEnergy(amount):
	energy += amount
	if energy > energyMax:
		energy = energyMax



func fullRecharge():
	laserCharges = laserChargesMax
	energy = energyMax
	oxygen = oxygenMax

func handleOxygenDrain(delta):
	oxygen -= delta
	# Die at -x, bar doesn't show below 0, screen starts flashing red... then game over
	if oxygen < -4.0:
		Globals.s_playerDied.emit()
		dead = true
		print("player - died from oxygen")


func generateEnergy(delta):
	energy += delta * energyGeneration

func generateOxygen(delta):
	var energyCost = delta * oxygenGenerationEnergyEfficiency
	#if energy >= delta and oxygen < oxygenMax:
	if energy >= energyCost and oxygen < oxygenMax:
		energy -= energyCost
		oxygen += delta * oxygenGenerationRate 

func generateLaser(delta):
	if not laserRegenerationOn:
		return
	var energyCost = delta * laserGenerationEnergyEfficiency
	#var unitProduction = energy * laserGenerationRate
	if laserCharges < laserChargesMax and energy > energyCost:
		energy -= energyCost
		laserCharges += delta * laserGenerationRate




func _physics_process(delta):
	if dead:
		return
	generateEnergy(delta)
	generateOxygen(delta)
	generateLaser(delta)
	handleOxygenDrain(delta)
	if not is_on_floor():
		velocity.y += _get_gravity(velocity) * delta
		_get_movement(air_resistance, air_acceleration, delta)
	else:
		#if coyote_timer.is_stopped():
			#coyote_timer.start()
		#if jump_buffer_timer.time_left > 0.0:
			#jump_buffer_timer.stop()
			#jump()
		_get_movement(friction, acceleration, delta)
	#_set_sprite_direction(sign(velocity.x))
	_set_flashlight_direction(sign(velocity.x))
	if Input.is_action_just_pressed("Jump"):
		jump()
		#_projected_jump_trojectory(delta, sign(velocity.x))
	if Input.is_action_just_released("Jump"):
		jump_cut()
	if Input.is_action_just_pressed("Fire"):
		fireLaser()
	if Input.is_action_just_released("Interact"):
		if currentInteractionObject != null:
			currentInteractionObject.playerInteraction()
	#if velocity != Vector2.ZERO:
		#$AnimatedSprite2D.play("walk")
	#else:
		#$AnimatedSprite2D.play("idle")
	move_and_slide()





# Sets the gravity depending on the context
func _get_gravity(_velocity):
	return jump_gravity if _velocity.y < 0.0 else fall_gravity


# Calculates the players movement depending on the context
func _get_movement(fric: float, accel: float, delta: float):
	var direction = Input.get_axis("Move_Left", "Move_Right")
	if direction:
		velocity.x += sign(direction) * accel * delta * 100
	
	if !direction or sign(direction) != sign(velocity.x):
		velocity.x = move_toward(velocity.x, 0, fric * delta * 100)
	
	if is_variable_max_speed:
		velocity.x = clamp(velocity.x, -max_speed * abs(direction), max_speed * abs(direction))
	else:
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
	
	if is_variable_min_speed and min_speed > 0:
			velocity.x = maxf(abs(velocity.x), abs(min_speed * sign(direction))) * sign(direction)




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
		$AnimatedSprite2D.flip_h = true
	elif direction < 0.0:
		$AnimatedSprite2D.flip_h = false
		
func _set_flashlight_direction(direction: int) -> void:
	#return
	#print("player - flashlight direction is: ", direction)
	if direction > 0.0: # moving right
		%Flashlight.rotation = 0
		%PlayerSprite.flip_h = false
	if direction < 0.0: # moving left
		%Flashlight.rotation = PI
		%PlayerSprite.flip_h = true
