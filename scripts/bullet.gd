extends Area2D

@export var speed: float = 500.0

func _process(delta):
	position.y -= speed * delta
	print("Bullet position: ", position)
	if position.y < -50:
		queue_free()
 
