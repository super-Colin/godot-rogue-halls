extends Node

enum RoomTypes {HALLWAY, SHAFT, ELBOW_UP, ELBOW_DOWN, TJUNCTION_UP, TJUNCTION_DOWN, DEADEND, OPEN, ENCLOSED}
enum DestinationTypes {TERRAN, STAR, GAS_PLANET, GALAXY, BLACKHOLE}

var uiRef
var playerRef
var playerInLevel = false
#var playerIsControllable = false
var playerIsControllable = true
#var levelRef
#var shipRef 

var confirmedDestination:Node


signal s_playerReady
signal s_playerDied

signal s_exitLevel
signal s_exitShip
signal s_startLevel

signal s_pauseRequested

signal s_playerLightsOff
signal s_playerLightsOn









#
