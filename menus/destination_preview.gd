extends Control

const destinationSpriteScene = preload("res://destination_sprite.tscn")





#func _ready() -> void:
	#await get_tree().process_frame
	#$VBoxContainer/Planet.scale = Vector2(2.0,2.0)




func updatePreview(destinationDict):
	print("preview - freeing: ", $SpriteHolder.get_children()[0])
	$SpriteHolder.get_children()[0].queue_free()
	print("dest display - planet dict is: ", destinationDict)
	var destSprite = destinationSpriteScene.instantiate()
	destSprite.freeUndisplayedPlanets(destinationDict.type)
	$SpriteHolder.add_child(destSprite) # causes bug, because of shared shader resource
	destSprite.setColors(destinationDict.colors)
	$Name.text = destinationDict.name
	$Description.text = destinationDict.description
	

















#
