extends KinematicBody2D

const ACCELERATION = 960
const MAX_SPEED = 155
const FRICTION = 900
var velocity = Vector2.ZERO
onready var animPlayer = $AnimationPlayer
onready var sprite = $Sprite
var _interactive : Area2D

func _physics_process(delta):
	var input_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if input_x < 0:
		sprite.flip_h = true
	elif input_x > 0:
		sprite.flip_h = false
	
	if input_x != 0:
		velocity = velocity.move_toward(Vector2(input_x, 0) * MAX_SPEED, ACCELERATION * delta)
		animPlayer.play("Run", -1, 2)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animPlayer.play("Idle")
	
	velocity = move_and_slide(velocity, Vector2.UP)

func SetInteractive(area : Area2D):
	_interactive = area

func ClearInteractive():
	_interactive = null
	
func _input(event):
	if event.is_action_pressed("interact"):
		if is_instance_valid(_interactive):
			_interactive.Interact()

