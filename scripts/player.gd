extends CharacterBody2D

@export var speed: float = 200.0
@export var bullet_scene: PackedScene
@export var fire_rate: float = 0.15
var screen_size # Size of the game window.
var fire_timer: float = 0.0

func _ready():
	print("Player script loaded")
	screen_size = get_viewport_rect().size

func _physics_process(_delta):
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_axis("ui_left", "ui_right")
	input_dir.y = Input.get_axis("ui_up", "ui_down")
	print("Input direction: ", input_dir)
	velocity = input_dir.normalized() * speed
	if velocity.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	position += velocity * _delta
	# Clamp using collision shape size
	var collision_shape = $CollisionShape2D.shape
	var shape_extents = Vector2.ZERO
	if collision_shape is CapsuleShape2D:
		shape_extents.x = collision_shape.radius
		shape_extents.y = collision_shape.height / 2.0
	position.x = clamp(position.x, shape_extents.x, screen_size.x - shape_extents.x)
	position.y = clamp(position.y, shape_extents.y, screen_size.y - shape_extents.y)
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
	move_and_slide()
	
func _process(delta):
	fire_timer -= delta
	if Input.is_action_pressed("ui_accept") and fire_timer <= 0:
		print("shooting")
		fire_bullet()
		fire_timer = fire_rate

func fire_bullet():
	print("fire_bullet called")
	var bullet = bullet_scene.instantiate()
	bullet.position = position
	get_tree().current_scene.add_child(bullet)
