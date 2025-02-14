extends Node2D

var health = 1
signal destroyed

@export var ballSprite: Texture2D = preload("res://sprites/pu-yellow-brick-extra-ball.png")
@export var paddleGrowSprite: Texture2D = preload("res://sprites/brick-paddle-grow.png")
@export var brickType: Enums.BRICK_TYPE
var rng = RandomNumberGenerator.new()

func _ready():
	randomizeBrick()
	setSprite()

func getHit():
	health -= 1
	if health <= 0:
		destroyed.emit(self)

func _on_area_2d_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if body.is_in_group("Ball"):
		getHit()

func setSprite():
	match brickType:
		Enums.BRICK_TYPE.BALL:
			$AnimatableBody2D/Sprite2D.texture = ballSprite
		Enums.BRICK_TYPE.PADDLEGROW:
			$AnimatableBody2D/Sprite2D.texture = paddleGrowSprite

func randomizeBrick():
	var roll = rng.randi_range(0, 100)
	if roll >= 90:
		var rollType = rng.randi_range(1, 2)
		if rollType == 1:
			brickType = Enums.BRICK_TYPE.BALL
		elif rollType == 2:
			brickType = Enums.BRICK_TYPE.PADDLEGROW
