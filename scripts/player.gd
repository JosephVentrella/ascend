extends CharacterBody2D

@export var speed: float = 1000.0
@export var bullet_scene: PackedScene
@export var fire_rate: float = 0.15
var fire_timer: float = 0.0
func _ready():
	print("Player script loaded")
func _physics_process(_delta):
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_axis("ui_left", "ui_right")
	input_dir.y = Input.get_axis("ui_up", "ui_down")

	velocity = input_dir.normalized() * speed

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
