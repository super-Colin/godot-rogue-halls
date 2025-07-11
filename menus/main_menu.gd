extends Control



signal newRun
signal s_releaseMenu


func _ready() -> void:
	#%StartButton.pressed.connect(func():newRun.emit())
	%StartButton.pressed.connect(func():s_releaseMenu.emit())
	%OptionsButton.pressed.connect(func():print("main menu - options pressed"))
	#%StartButton.pressed.connect(releaseMainMenu)






#func releaseMainMenu():
	#Globals.playerIsControllable = true
	#$'.'.visible = false


func _physics_process(delta: float) -> void:
	#if Input.get_axis("Move_Left", "Move_Right") != 0:
		#print("menu - player moved")
	pass
