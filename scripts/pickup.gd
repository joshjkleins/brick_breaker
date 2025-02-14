extends Node2D

#DROPS
var paddleGrow: Texture2D = preload("res://sprites/paddle-grow-drop.png")


@export var dropType: Enums.BRICK_TYPE

func _process(delta):
	position.y = position.y + delta * 300

func setType(drop):
	dropType = drop
	match dropType:
		Enums.BRICK_TYPE.PADDLEGROW:
			$Sprite2D.texture = paddleGrow
