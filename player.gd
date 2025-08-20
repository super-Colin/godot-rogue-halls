class_name Player
extends CharacterBody2D


const weapon = preload("res://gun.tscn")



@export_group("Movement")
## Maximum speed reachable by player
@export_range(0, 500) var max_speed := 300.0
@export_range(0, 500) var max_speed_influence := 200.0
## Acceleration while on the ground (how quickly the player reaches max speed)
@export_range(0, 500) var acceleration := 100.0
## Friction while on group (how quickly the player slows down)
@export_range(0, 50) var friction := 50.0
## Acceleration while in the air (how quickly the player reaches max speed)
@export_range(0, 500) var air_acceleration := 5.0
## Air friction while in the air (how quickly the player slows down)
@export_range(0, 50) var air_resistance := 50.0


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


@onready var jump_velocity : float = (2.0 * jump_height) / jump_time_to_peak * -1
#@onready var jump_gravity : float = (-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak) * -1
#@onready var fall_gravity : float = (-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent) * -1




# ----
@export var handReach = 60
@export var handAngularSpeed: float = 10.0  # Radians per second

var dead = false
var currentInteractionObject:Node
var currentEnvironmentRef:Node
var camera:Node
var handFacing

var weaponGenerationOn = true


var responseToAnimationFinished

signal updateInteractionPrompt(string)



# ? Maybe ? make the hand the collision that needs to overlap with interactables??
# A gun that is just a jet pack with a huge battery

func _ready():
	Globals.playerRef = $'.'
	%PickupRange.area_entered.connect(checkForPromptUpdate.bind(true))
	%PickupRange.area_exited.connect(checkForPromptUpdate.bind(false))
	%PickupRange.body_entered.connect(checkForPromptUpdate.bind(true))
	%PickupRange.body_exited.connect(checkForPromptUpdate.bind(false))
	clearInteractionOject()
	camera = $Camera2D
	Globals.s_playerLightsOff.connect(turnLightsOff)
	Globals.s_playerLightsOn.connect(turnLightsOn)
	%PlayerSprite.sprite_frames.set_animation_loop("Death", false)
	setupHeldItem()
	Globals.s_playerReady.emit()

func setupHeldItem():
	var heldItem = $Hand.getHeldItem()
	if heldItem:
		if "setupWeapon" in heldItem:
			heldItem.setupWeapon(Stats.weapon.maxBonusPercent, Stats.weapon.maxBonusFlat, Stats.weapon.generationBonusPercent)
	

func _process(delta: float) -> void:
	if dead:
		return
	trackMouseWithHandDelta(delta)









# Sets the gravity depending on the context
#func _get_gravity(_velocity):
	#return jump_gravity if _velocity.y < 0.0 else fall_gravity



func _physics_process(delta):
	var onFloor = is_on_floor()
	var facingBackward = velocity.x != 0.0 and sign(velocity.x) != sign($Hand.position.x)
	_set_player_direction(sign($Hand.position.x)) # hand is tracking mouse in _process()
	# Even if the player cannot control the character, apply gravity
	if not onFloor:
		velocity += get_gravity() * delta
	#if dead or not Globals.playerIsControllable:
	if not dead and Globals.playerIsControllable:
		if not onFloor:
			_get_movement(air_resistance, air_acceleration, delta)
		else:
			_get_movement(friction, acceleration, delta)
		# fire laser / jump etc..
		handleInputs(onFloor, facingBackward)
		# Charge oxgen / laser 
		setSpriteAnimation(onFloor, facingBackward)
		handleRecharges(delta)
	move_and_slide()

func handleRecharges(delta):
	if currentEnvironmentRef:
		if currentEnvironmentRef.infiniteEnergy:
			fullRecharge()
	else:
		# Oxygen / Health / Energy
		suitGeneration(delta)
		# External Generations / Drains
		weaponGeneration(delta)
		#equipmentGeneration(delta)
		# Environmental Generations / Drains
		handleOxygenDrain(delta)

func handleInputs(onFloor, facingBackward=false):
	#if Input.is_action_just_pressed("Jump"):
	if Input.is_action_pressed("Jump"):
		if onFloor:
			jump()
			onFloor = false # so that walk animation doesn't cut this off
		else:
			#print("player - should use jet pack")
			useJetpack()
	elif Input.is_action_just_released("Jump"):
		jump_cut()
	if Input.is_action_just_pressed("Fire"):
		fireLaser()
	if Input.is_action_just_released("Interact"):
		if currentInteractionObject != null:
			#print("player - interacting with object: ", currentInteractionObject)
			currentInteractionObject.playerInteraction()


func setSpriteAnimation(onFloor, facingBackward=false):
	if onFloor:
		if velocity.x != 0:
			if facingBackward:
				%PlayerSprite.play_backwards("Walking")
			else:
				%PlayerSprite.play("Walking")
		else:
				%PlayerSprite.play("Idle")
	else: 
		if velocity.y > 0:
			%PlayerSprite.play("Falling")
		else:
			%PlayerSprite.play("Jetpack")


# Calculates the players movement depending on the context
func _get_movement(fric: float, accel: float, delta: float):
	var direction = Input.get_axis("Move_Left", "Move_Right")
	var walkingInfluence
	if direction:
		walkingInfluence = sign(direction) * accel * delta * 100
		# if not at max speed 
		if sign(direction) != sign(velocity.x) or (not velocity.x < -max_speed and not velocity.x > max_speed):
			velocity.x += walkingInfluence 
		else:
			velocity.x = move_toward(velocity.x, max_speed, fric * delta * 100)
	else:
		velocity.x = move_toward(velocity.x, 0, fric * delta * 100)




func useJetpack():
	print("player - using jet pack")













func suitGeneration(delta):
	generateEnergy(delta)
	generateOxygen(delta)

func weaponGeneration(delta):
	var energyCost = $Hand.getHeldItem().getGenerationEnergyCost(delta)
	if canAffordEnergyCost(energyCost):
		drainEnergy(energyCost)
		$Hand.getHeldItem().generateAmmo(delta)
		#generateWeapon(delta)

func canAffordEnergyCost(cost)->bool:
	return Stats.energy.current > cost



func generateWeapon(delta):
	#if not Stats.laserRegenerationOn:
		#return
	var energyCost = delta * Stats.weapon.generationEfficiency
	#var unitProduction = energy * laserGenerationRate
	if Stats.laserCharges < Stats.laserChargesMax and Stats.energy > energyCost:
		Stats.energy -= energyCost
		Stats.laserCharges += delta * Stats.laserGenerationRate



func generateOxygen(delta):
	var energyCost = (Stats.oxygen.generationRate * delta) * Stats.oxygen.generationEfficiency
	if Stats.energy.current >= energyCost and Stats.oxygen.current < Stats.functionalMax("oxygen"):
		Stats.energy.current -= energyCost 
		Stats.oxygen.current += delta * Stats.oxygen.generationRate 

func fullRecharge():
	#Stats.laserCharges = Stats.laserChargesMax
	Stats.energy.current = Stats.energy.max
	Stats.oxygen.current = Stats.oxygen.max

func handleOxygenDrain(delta):
	Stats.oxygen.current -= delta
	if Stats.oxygen.current < -4.0: # a few seconds of red screen
		playerDied()
		#print("player - died from oxygen")


func generateEnergy(delta):
	var amount = Stats.energy.generationRate * delta
	rechargeEnergy(amount)
func rechargeEnergy(amount):
	Stats.energy.current = clamp(Stats.energy.current + amount, 0, Stats.functionalMax("energy"))
func drainEnergy(amount):
	Stats.energy.current = clamp(Stats.energy.current - amount, 0, Stats.functionalMax("energy"))
	if Stats.energy.current == 0:
		print("player - out of energy, can't drain...")




func fireLaser():
	if "fireWeapon" in $Hand.heldObject:
		if $Hand.heldObject.fireWeapon():
			var recoilImpulse = Vector2(-2000,0).rotated($Hand.heldObject.global_rotation)
			print("player - laser recoil impulse: ", recoilImpulse)
			$'.'.velocity += recoilImpulse













func checkForPromptUpdate(areaOrBody:Node, entered:bool): # entered or exited
	if not "playerInteraction" in areaOrBody:
		return
	if entered:
		#print("player: object is usable: ", areaOrBody)
		currentInteractionObject = areaOrBody
		updatePrompt(currentInteractionObject.interactionPrompt)
	elif areaOrBody == currentInteractionObject and not entered:
		clearInteractionOject()

func clearInteractionOject():
	updateInteractionPrompt.emit("")
	currentInteractionObject = null
	%InteractionPrompt.visible = false

func updatePrompt(newPrompt):
	%InteractionPrompt.text = newPrompt
	%InteractionPrompt.visible = true















# Adds the player's jump velocity if able
func jump():
	velocity.y = jump_velocity
	#%PlayerSprite.play("Jetpack")
	#responseToAnimationFinished = ""


# Stops jump acceleration if variable_jump_height is enabled
func jump_cut():
	if not variable_jump_height:
		return
	if velocity.y < minimum_jump_height * up_direction.y:
		velocity.y = minimum_jump_height * up_direction.y



func flipDirection():
	print("player - flipping direction")
	if %PlayerSprite.flip_h:
		_set_player_direction(1)
	else:
		_set_player_direction(-1)

func _set_player_direction(direction: int) -> void:
	#return
	#print("player - flashlight direction is: ", direction)
	if direction > 0.0: # moving right
		%Flashlight.rotation = 0
		#%PlayerSprite.flip_h = false
		%PlayerSprite.flip_h = false
	if direction < 0.0: # moving left
		%Flashlight.rotation = PI
		#%PlayerSprite.flip_h = true
		%PlayerSprite.flip_h = true






#func trackMouseWithHand():
	#$Hand.position = handReach * get_local_mouse_position().normalized()

func trackMouseWithHandDelta(delta):
	var origin = Vector2.ZERO  # assuming local space origin
	var mouse_pos = get_local_mouse_position()
	# Current angle of the hand (based on its position)
	var current_angle = $Hand.position.angle()
	# Target angle from origin to mouse
	var target_angle = mouse_pos.angle()
	# Move the current angle toward the target angle
	var new_angle = move_toward_angle(current_angle, target_angle, handAngularSpeed * delta)
	# Update hand position
	$Hand.position = Vector2(handReach, 0).rotated(new_angle)
	# Optionally rotate the hand to point outward
	$Hand.rotation = new_angle


func move_toward_angle(from_angle: float, to_angle: float, max_step: float) -> float:
	var delta = wrapf(to_angle - from_angle, -PI, PI)
	if abs(delta) <= max_step:
		return to_angle
	return from_angle + sign(delta) * max_step











func turnLightsOff():
	#$PointLight2D.visible = false
	#return
	$Flashlight.visible = false
func turnLightsOn():
	#$PointLight2D.visible = true
	#return
	$Flashlight.visible = true






func playerDied():
	Globals.s_playerDied.emit()
	dead = true
	%PlayerSprite.modulate = "aa5853"
	%PlayerSprite.play("Death")
	$Hand.dropHeldItem()




func enteredEnvironment(newEnvironment):
	if newEnvironment is EnvironmentSettings:
		currentEnvironmentRef = newEnvironment
		#print("player - entered newEnvironment: ", newEnvironment)

func exitedEnvironment(environment):
	if environment == currentEnvironmentRef:
		currentEnvironmentRef == null
		#print("player - exited the environment: ", environment)




func checkIfAnimationShouldStop():
	print("player - checking if dead: ", %PlayerSprite.animation)
	if %PlayerSprite.animation == "Dieing":
		print("player - player is dead: ")
		%PlayerSprite.stop()





#
