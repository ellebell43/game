extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var jumpPlayer = $JumpAudioPLayer
@onready var camera = $Camera2D
@onready var idleTimer = $IdleTimer

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
	if Input.is_action_just_pressed("jump") and is_on_floor() and !Input.is_action_pressed("crouch"):
		idleTimer.start()
		velocity.y = JUMP_VELOCITY
		jumpPlayer.play()
		sprite.play("jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true
	
	if direction and not Input.is_action_pressed("crouch"):
		idleTimer.start()
		if Input.is_action_pressed("sprint"):
			velocity.x = direction * SPEED * 1.5
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 10)
	
	#ANIMATION TREE
	if Input.is_action_pressed("crouch"):
		sprite.play("crouch")
	elif velocity.x != 0 and velocity.y == 0:
		if Input.is_action_pressed("sprint"):
			sprite.play("walk")
		else:
			sprite.play("run")
	elif velocity.x == 0 and velocity.y == 0 and idleTimer.is_stopped():
		sprite.play("idle")
	elif velocity.x == 0 and velocity.y == 0:
		sprite.play("stand")
	elif velocity.y > 250:
		sprite.play("fall")

	move_and_slide()
