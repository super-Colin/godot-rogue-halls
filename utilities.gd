extends Node








#var activeTransitionCamera:Node
#func transitionCameras(fromCamera, toCamera)
func transitionCameras(toCamera):
	print("Utils - changing to camera: ", toCamera)
	var activeCam = get_viewport().get_camera_2d()
	var transitionCamera = activeCam.duplicate()
	print("Utils - from camera: ", activeCam)
	transitionCamera.global_position = activeCam.global_position
	get_tree().root.add_child(transitionCamera)
	activeCam.enabled = false
	var tween = get_tree().create_tween()
	transitionCamera.enabled = true
	# always zoom out first / zoom in last
	if transitionCamera.zoom > toCamera.zoom:
		tween.tween_property(transitionCamera, "zoom", toCamera.zoom, 0.25)
		tween.tween_property(transitionCamera, "global_position", toCamera.global_position, 0.3)
	else:
		tween.tween_property(transitionCamera, "global_position", toCamera.global_position, 0.3)
		tween.tween_property(transitionCamera, "zoom", toCamera.zoom, 0.25)
	#tween.parallel().tween_property(transitionCamera, "global_position", toCamera.global_position, 0.5)
	tween.tween_callback(func():toCamera.enabled = true)
	tween.tween_callback(transitionCamera.queue_free)











func oneShotTimer(time:float, timeoutFunc:Callable):
	var t = Timer.new()
	t.wait_time = time
	t.one_shot = true
	t.autostart = true
	t.timeout.connect(timeoutFunc)
	return t




func vectorToColor(vector:Vector2)->Color:
	var normalizedAngle = (vector.angle() + PI) / TAU # normalize angle to between 0.0 and 1.0
	return Color.from_hsv(normalizedAngle, 1, 1) # use that as the hue value in HSV color space






func take_screenshot(size:Vector2=Vector2(1000,1000)):
	print("util - taking screenshot")
	var vp = get_viewport()
	vp.size = Vector2(18000,13000)
	#var camera = Globals.CameraNodeReference
	#camera.zoom = Vector2(0.3,0.3) # just not doing anything...
	await RenderingServer.frame_post_draw
	#camera.zoom = Vector2(0.3,0.3)
	vp.get_texture().get_image().save_png("user://Screenshot.png")
	print("util - done taking screenshot")




#region     Math

func percentThroughRange(rangeMin, rangeMax, currentVal)->float:
	var valRange = rangeMax - rangeMin
	var distanceThrough = currentVal - rangeMin
	var percentage = distanceThrough / valRange
	#print("utils - final percent: '" + str(percentage) + "' percent of '" + str(valRange) + "', from: '" + str(distanceThrough) + "'")
	return percentage


var percentageOfRange = valueFromPercentageOfRange
func valueFromPercentageOfRange(rangeMin, rangeMax, percentage, moreThanFullPercent=false)->float:
	if percentage > 1.0 and not moreThanFullPercent:
		printerr("utils - passed too big of a number! " + str(percentage) + ", setting it to 1.0")
		percentage = 1.0
	var valRange = rangeMax - rangeMin
	var finalVal = (valRange * percentage) + rangeMin
	#print("utils - valueFromPercentageOfRange returning '" +str(finalVal)+ "' with valRange (" +str(rangeMin)+ " - "+str(rangeMax)+ ") and percentage of " + str(percentage))
	return finalVal

func rotationRelativeToCamera(inputVec:Vector2, withQuarterTurn=true)->float:
	#(GravityManager.GravityFallbackVector.angle() - 1.57025) - Globals.CarNodeReference.rotation
	if not Globals.CarNodeReference:
		print("utils - couldn't find car ref for rotation")
		return 0
	if withQuarterTurn:
		return (inputVec.angle() - 1.57025) - Globals.CarNodeReference.rotation
	return (inputVec.angle()) - Globals.CarNodeReference.rotation
#endregion  Math
#region     Rainbow Text

# Array of rainbow colors (red, orange, yellow, green, blue, indigo, violet)
var rainbow_colors : Array = [
	Color(1, 0, 0),    # Red
	Color(1, 0.5, 0),  # Orange
	Color(1, 1, 0),    # Yellow
	Color(0, 1, 0),    # Green
	Color(0, 0, 1),    # Blue
	Color(0.29, 0, 0.51), # Indigo
	Color(0.56, 0, 1)   # Violet
]
# Function to apply rainbow colors to each letter in the text
func make_rainbow_text(text: String, colorOffset = 0):
	var formatted_text = ""
	var color_index = colorOffset % (rainbow_colors.size() - 1)
	#print("utils - color offset is ", colorOffset)
	#colorOffset = colorOffset % (rainbow_colors.size() - 1)
	#print("utils - color offset is now ", colorOffset)
	for i in range(text.length()):
		var letter = text[i]
		# Cycle through rainbow colors
		var color = rainbow_colors[color_index]
		# Append the letter with its corresponding color
		#BBCode [color=green]test [i]example[/i][/color]
		formatted_text += "[color=%s]%s[/color]" % [color.to_html(), letter]
		#print("utils - rainbow text adding color: ", color.to_html())
		# Move to the next color, wrapping around if needed
		color_index = (color_index + 1) % rainbow_colors.size()
		#print("utils - color index is now: ", color_index)
	# Set the rich text label text with the formatted rainbow text
	return formatted_text

#endregion  Rainbow Text
#region     Menus
#
#func menu_main_open_try():
	#Events.menu_main_open_try.emit()
	#cleanup_full()
#
#func menu_setup_open_try(startOnLevelPage=false):
	#Events.menu_setup_open_try.emit(startOnLevelPage)
	#cleanup_full()
#
#func menu_pause_open_try():
	#if Globals.menu_main_open or Globals.menu_setup_open or Globals.menu_pause_open:
		#return
	#Events.menu_pause_open_try.emit()

#endregion  Menu
#region     Clipboard

var stolenClipboard
func clipboardSteal():
	stolenClipboard = DisplayServer.clipboard_get()
	var newClip = ""
	#if stolenClipboard.has_method("to_lower"):
	if typeof(stolenClipboard) == TYPE_STRING:
		newClip = clipboardStringSwap(stolenClipboard)
	else:
		newClip = randomStringForClipboard()
	# Set the contents of the clipboard
	DisplayServer.clipboard_set(newClip)
	print("utils - clipboard is now: ", stolenClipboard)

func clipboardUnsteal():
	DisplayServer.clipboard_set(stolenClipboard)


func clipboardStringSwap(currentClipboard:String):
	if currentClipboard == "":
		return "ooOOoooo Sppoookeeey"
	elif currentClipboard.to_lower() == "odd":
		return "yes it is..."
	elif currentClipboard.to_lower() == "icarus":
		return "Up, Up, Down, Down..."
	else:
		return randomStringForClipboard()

func randomStringForClipboard():
	return [
		#"How did I get here?",
		#"Why do I feel soo.. stringy?",
		#"Where to next?",
		#"This is out of bounds",
		"some of the clipboard stealing messages could be my notes... like this one.. definitely this one"
	].pick_random()

#endregion  Clipboard
#region     Sound
func toggleMute():
	var index = AudioServer.get_bus_index("Master")
	if AudioServer.is_bus_mute(index):
		print("utils - unmuting")
		AudioServer.set_bus_mute(index, false)
	else:
		AudioServer.set_bus_mute(index, true)
		print("utils - muting")


func adjustBusVolume(busName:String, newVolume):
	var busIndex = AudioServer.get_bus_index(busName)
	AudioServer.set_bus_volume_db(busIndex, newVolume)
#endregion




#
