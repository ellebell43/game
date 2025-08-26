extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var jumpPlayer = $JumpAudioPLayer
@onready var camera = $Camera2D

@export var cameraLimitTop = 500
@export var cameraLimitBottom = 500
@export var cameraLimitLeft = 500
@export var cameraLimitRight = 500


const SPEED = 100.0
const JUMP_VELOCITY = -250.0

func _ready() -> void:
	camera.limit_bottom = cameraLimitBottom
	camera.limit_top = cameraLimitTop
	camera.limit_right = cameraLimitRight
	camera.limit_left = cameraLimitLeft


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumpPlayer.play()
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if velocity.x != 0:
		sprite.play("run")
	else:
		sprite.play("idle")

	move_and_slide()
