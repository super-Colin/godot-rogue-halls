extends Area2D




func _ready() -> void:
	area_entered.connect(entered)
	body_entered.connect(entered)
	area_exited.connect(exited)
	body_exited.connect(exited)



func entered(body):
	if body == Globals.playerRef:
		print("environment - PLAYER entered: ", body)
	print("environment - entered: ", body)



func exited(body):
	print("environment - entered: ", body)















#
