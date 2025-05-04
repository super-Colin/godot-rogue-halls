extends Node





func directionToPlayer(aiNode:CharacterBody2D):
	return (Globals.playerRef.global_position - aiNode.global_position)

func attackPlayer(aiNode:CharacterBody2D):
	var direction = directionToPlayer(aiNode)












#
