extends CharacterBody2D

var bounceIt = false

# Called every physics frame
func _physics_process(delta):
	# Move the body and handle collisions
	
	var collision = move_and_collide(velocity * delta)
	# Handle collision response
	if collision:
		velocity = velocity.bounce(collision.get_normal())
	if bounceIt and collision:
		velocity = velocity.bounce(collision.get_normal())
		bounceIt = false

func bounceItUp():
	bounceIt = true

func die():
	call_deferred("queue_free")
