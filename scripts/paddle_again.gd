extends Node2D
var sizeOfPlayField
var sizeOfPaddle 
var offsetOfPaddle

@export var paddleSpeed = 5000
@export var cameraZoom = 1

var ballBounceVelocity = -1000
var currentSpeed = 0
var currentDir
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	sizeOfPlayField = get_viewport_rect().size
	sizeOfPaddle = $Sprite2D.texture.get_width()
	offsetOfPaddle = sizeOfPaddle * 5 / 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("left"):
		currentDir = "left"
		currentSpeed += delta * 4 #accelaration
		if currentSpeed > 2:
			currentSpeed = 2
		position.x -= (2 + currentSpeed) * delta * paddleSpeed
	elif Input.is_action_pressed("right"):
		currentDir = "right"
		currentSpeed += delta * 4
		if currentSpeed > 2:
			currentSpeed = 2
		position.x += (2 + currentSpeed) * delta * paddleSpeed
	else:
		#deccelaration
		currentSpeed -= delta * 12
		if currentDir == "left":
			if currentSpeed > 0:
				position.x -= currentSpeed
		elif currentDir == "right":
			if currentSpeed > 0:
				position.x += currentSpeed
			
		if currentSpeed < 0:
			currentSpeed = 0
	position = position.clamp(Vector2(0 + offsetOfPaddle, 0), (sizeOfPlayField / cameraZoom) - Vector2(offsetOfPaddle - 10, 0))



func _on_area_2d_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if body.is_in_group("Ball"):
		var relativePos = self.to_local(body.global_position)
		if relativePos.x <= -130: #far left
			body.velocity = Vector2(rng.randi_range(-500, -800), ballBounceVelocity)
		elif relativePos.x < -50: #left 
			body.velocity = Vector2(rng.randi_range(-250, -500), ballBounceVelocity)
		elif relativePos.x >= 130: #far right
			body.velocity = Vector2(rng.randi_range(500, 800), ballBounceVelocity)
		elif relativePos.x > 50: #right 
			body.velocity = Vector2(rng.randi_range(250, 500), ballBounceVelocity)
		else: #middle of paddle hit
			var xVelocity = body.velocity.x
			body.velocity = Vector2(xVelocity, ballBounceVelocity)
