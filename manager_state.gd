extends Node


enum states {menu, cutscene, ship, level}
enum stateModifiers {paused, blind}
enum menus {main, ship, pause, game_over}


var currentState:states = states.menu
var currentModifiers = []

signal s_stateChanging(newState:states)
signal s_stateChanged


func canChangeStateTo(newState:states)->bool:
	if currentState == newState:
		return false # false if is already in that state
	#currentState = newState
	#s_stateChanged.emit()
	s_stateChanging.emit(newState)
	return true

#func updatePausableState():
	#if Globals.menu_main_open or Globals.menu_pause_open or Globals.menu_setup_open:
		#Globals.Pausable = false
	#else:
		#Globals.Pausable = true
#
#func whichMenuIsOpen():
	#if Globals.menu_main_open :
		#print("utils - menu_main_open already open")
	#elif Globals.menu_setup_open :
		#print("utils - menu_setup_open already open")
	#elif Globals.menu_pause_open:
		#print("utils - menu_pause_open already open")











#
