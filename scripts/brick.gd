extends Node2D

var health = 1
signal destroyed

enum BRICK_TYPE { NORMAL, BALL, SHOOTER, PADDLEGROW, PADDLESHRINK, PADDLESLOW }

@export var ballSprite: Texture2D
@export var brickType: BRICK_TYPE
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
		BRICK_TYPE.BALL:
			$AnimatableBody2D/Sprite2D.texture = ballSprite

func randomizeBrick():
	var roll = rng.randi_range(0, 100)
	if roll >= 75:
		brickType = BRICK_TYPE.BALL
	
