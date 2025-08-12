#@tool
class_name Player
extends CharacterBody2D

#var laserProjectileScene = preload("res://laser_projectile.tscn")

const weapon = preload("res://gun.tscn")



@onready var coyote_timer = $CoyoteTimer
@onready var jump_buffer_timer = $JumpBufferTimer
#@onready var jump_trojectory_line = $JumpTrojectoryLine

#@export_tool_button("Flip X Direction")
#var flipXDirectionAction = flipDirection

@export_group("Movement")
## Maximum speed reachable by player
@export_range(0, 500) var max_speed := 200.0
## Minimum speed when variable_min_speed is set to true & min_speed isn't 0
#@export_range(0, 500) var min_speed := 0.0
## Acceleration while on the ground (how quickly the player reaches max speed)
@export_range(0, 500) var acceleration := 100.0
## Friction while on group (how quickly the player slows down)
@export_range(0, 50) var friction := 50.0
## Acceleration while in the air (how quickly the player reaches max speed)
@export_range(0, 500) var air_acceleration := 5.0
## Air friction while in the air (how quickly the player slows down)
@export_range(0, 50) var air_resistance := 50.0
## Sets a variable max speed depending on how far the joystick is pushed
#@export var is_variable_max_speed := false
### sets a minimum speed based on min_speed
#@export var is_variable_min_speed := false

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
@onready var jump_gravity : float = (-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak) * -1
@onready var fall_gravity : float = (-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent) * -1




# ----
@export var handReach = 130
@export var handAngularSpeed: float = 10.0  # Radians per second

var dead = false
var currentInteractionObject:Node
var currentEnvironmentRef:Node
var camera:Node
var handFacing



signal updateInteractionPrompt(string)




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



# ? Maybe ? make the hand the collision that needs to overlap with interactables??









func _ready():
	if Engine.is_editor_hint():
		return
	Globals.playerRef = $'.'
	%PickupRange.area_entered.connect(checkForPromptUpdate.bind(true))
	%PickupRange.area_exited.connect(checkForPromptUpdate.bind(false))
	%PickupRange.body_entered.connect(checkForPromptUpdate.bind(true))
	%PickupRange.body_exited.connect(checkForPromptUpdate.bind(false))
	clearInteractionOject()
	camera = $Camera2D
	Globals.s_playerLightsOff.connect(turnLightsOff)
	Globals.s_playerLightsOn.connect(turnLightsOn)
	Globals.s_playerReady.emit()
	#coyote_timer.wait_time = coyote_timer_value
	#jump_buffer_timer.wait_time = jump_buffer_timer_value


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if dead:
		return
	trackMouseWithHandDelta(delta)
	#trackMouseWithHand()

func _physics_process(delta):
	if Engine.is_editor_hint():
		return
	if dead:
		return
	if not is_on_floor():
		velocity.y += _get_gravity(velocity) * delta
		if Globals.playerIsControllable: _get_movement(air_resistance, air_acceleration, delta)
	else:
		#if coyote_timer.is_stopped():
			#coyote_timer.start()
		#if jump_buffer_timer.time_left > 0.0:
			#jump_buffer_timer.stop()
			#jump()
		if Globals.playerIsControllable: _get_movement(friction, acceleration, delta)
	# Even if the player cannot control the character, apply gravity
	if not Globals.playerIsControllable:
		move_and_slide()
		return
	#_set_player_direction(sign(velocity.x))
	_set_player_direction(sign($Hand.position.x))
	if velocity.x > 0.1 and sign(velocity.x) != sign($Hand.position.x):
		print("player - looking / walking backwards: ", sign(velocity.x))
	if Input.is_action_just_pressed("Jump"):
		jump()
		#_projected_jump_trojectory(delta, sign(velocity.x))
	if Input.is_action_just_released("Jump"):
		jump_cut()
	if Input.is_action_just_pressed("Fire"):
		fireLaser()
	if Input.is_action_just_released("Interact"):
		if currentInteractionObject != null:
			#print("player - interacting with object: ", currentInteractionObject)
			currentInteractionObject.playerInteraction()
	#if velocity != Vector2.ZERO:
		#$AnimatedSprite2D.play("walk")
	#else:
		#$AnimatedSprite2D.play("idle")
	if currentEnvironmentRef:
		if currentEnvironmentRef.infiniteEnergy:
			fullRecharge()
	else:
		generateEnergy(delta)
		generateOxygen(delta)
		generateLaser(delta)
		handleOxygenDrain(delta)
	move_and_slide()






## TODO: will be moved to gun class
func fireLaser():
	#print("player - firing laser, charges left: ", Stats.laserCharges)
	if Stats.laserCharges < 1:
		return
	Stats.laserCharges -= 1
	if "fireLaser" in $Hand.heldObject:
		$Hand.heldObject.fireLaser()
	#var las = laserProjectileScene.instantiate()
	#las.position = $'.'.global_position
	#get_tree().root.add_child(las)




func checkForPromptUpdate(areaOrBody:Node, entered:bool): # entered or exited
	if not "playerInteraction" in areaOrBody:
		return
	if entered:
		#print("player: object is usable: ", areaOrBody)
		currentInteractionObject = areaOrBody
		#updateInteractionPrompt.emit(currentInteractionObject.interactionPrompt)
		updatePrompt(currentInteractionObject.interactionPrompt)
	elif areaOrBody == currentInteractionObject and not entered:
		#updateInteractionPrompt.emit("")
		clearInteractionOject()

func clearInteractionOject():
	updateInteractionPrompt.emit("")
	currentInteractionObject = null
	%InteractionPrompt.visible = false

func rechargeEnergy(amount):
	Stats.energy += amount
	if Stats.energy > Stats.energyMax:
		Stats.energy = Stats.energyMax


func updatePrompt(newPrompt):
	%InteractionPrompt.text = newPrompt
	%InteractionPrompt.visible = true




func fullRecharge():
	Stats.laserCharges = Stats.laserChargesMax
	Stats.energy = Stats.energyMax
	Stats.oxygen = Stats.oxygenMax

func handleOxygenDrain(delta):
	Stats.oxygen -= delta
	# Die at -x, bar doesn't show below 0, screen starts flashing red... then game over
	if Stats.oxygen < -4.0:
		Globals.s_playerDied.emit()
		dead = true
		%PlayerSprite.modulate = "aa5853"
		#print("player - died from oxygen")


func generateEnergy(delta):
	Stats.energy += delta * Stats.energyGeneration

func generateOxygen(delta):
	var energyCost = delta * Stats.oxygenGenerationEnergyEfficiency
	#if energy >= delta and oxygen < oxygenMax:
	if Stats.energy >= energyCost and Stats.oxygen < Stats.oxygenMax:
		Stats.energy -= energyCost
		Stats.oxygen += delta * Stats.oxygenGenerationRate 

func generateLaser(delta):
	if not Stats.laserRegenerationOn:
		return
	var energyCost = delta * Stats.laserGenerationEnergyEfficiency
	#var unitProduction = energy * laserGenerationRate
	if Stats.laserCharges < Stats.laserChargesMax and Stats.energy > energyCost:
		Stats.energy -= energyCost
		Stats.laserCharges += delta * Stats.laserGenerationRate









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
	
	#if is_variable_max_speed:
		#velocity.x = clamp(velocity.x, -max_speed * abs(direction), max_speed * abs(direction))
	#else:
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
		%PlayerSprite.flip_h = false
	if direction < 0.0: # moving left
		%Flashlight.rotation = PI
		%PlayerSprite.flip_h = true










func turnLightsOff():
	#$PointLight2D.visible = false
	$Flashlight.visible = false
func turnLightsOn():
	#$PointLight2D.visible = true
	$Flashlight.visible = true








func enteredEnvironment(newEnvironment):
	if newEnvironment is EnvironmentSettings:
		currentEnvironmentRef = newEnvironment
		#print("player - entered newEnvironment: ", newEnvironment)

func exitedEnvironment(environment):
	if environment == currentEnvironmentRef:
		currentEnvironmentRef == null
		#print("player - exited the environment: ", environment)







#
