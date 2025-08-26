extends CharacterBody2D


var heldObject:Node




func _ready() -> void:
	heldObject = $'.'.get_node("Gun")



func dropHeldItem():
	$PinJoint2D.node_b = NodePath("")

func getHeldItem():
	return heldObject


func _exit_tree() -> void:
	if heldObject:
		heldObject.queue_free()








#
