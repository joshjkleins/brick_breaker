extends Node2D
@onready var another_ball = $AnotherBall
@onready var paddle_again = $PaddleAgain

var bricksScene = preload("res://scenes/bricks.tscn")
var ballScene = preload("res://scenes/another_ball.tscn")

var remainingBalls
var canLaunch = true

var currentMainBall

# Called when the node enters the scene tree for the first time.
func _ready():
	remainingBalls = 0
	spawnNewBricks()
	spawnBall()


func _process(delta):
	if canLaunch and currentMainBall:
		currentMainBall.position = paddle_again.position
	if Input.is_action_just_pressed("launch") and canLaunch:
		currentMainBall.velocity = Vector2(50, -1000)
		canLaunch = false

func _on_death_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if body.is_in_group("Ball"):
		body.die()
		remainingBalls -= 1
	if remainingBalls <= 0:
		lose()

func lose():
	reset()

func reset():
	spawnBall()

func spawnBall():
	var newBall = ballScene.instantiate()
	remainingBalls += 1
	call_deferred("add_child", newBall)
	canLaunch = true
	currentMainBall = newBall

func spawnNewBricks():
	var newBricks = bricksScene.instantiate()
	call_deferred("add_child", newBricks)
	for b in newBricks.get_children():
		b.connect("destroyed", brickDestroyed)

func brickDestroyed(brick):
	if brick.brickType != 0:
		match brick.brickType:
			1: #spawn extra ball
				var newBall = ballScene.instantiate()
				call_deferred("add_child", newBall)
				newBall.position = brick.position + Vector2(0, 500)
				remainingBalls += 1
				newBall.velocity = Vector2(50, -1000)
	brick.call_deferred("free")
	var currentBricks = get_node("Bricks")
	if currentBricks:
		if currentBricks.get_children().size() <= 1:
			var nodeToRemove = get_node("Bricks")
			call_deferred("remove_child", nodeToRemove)
			spawnNewBricks()
