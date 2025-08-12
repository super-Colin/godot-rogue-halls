extends CharacterBody2D


var heldObject:Node




func _ready() -> void:
	heldObject = $'.'.get_node("Gun")





func _exit_tree() -> void:
	if heldObject:
		heldObject.queue_free()








#
