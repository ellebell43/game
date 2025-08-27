extends CharacterBody2D

# node references
@onready var sprite = $AnimatedSprite2D
@onready var jumpPlayer = $JumpAudioPLayer
@onready var camera = $Camera2D
@onready var idleTimer = $IdleTimer
@onready var gameOverPlayer = $GameOverPlayer
@onready var worldCollision = $WorldCollision

# exported variables
@export var cameraLimitTop = 500
@export var cameraLimitBottom = 500
@export var cameraLimitLeft = 500
@export var cameraLimitRight = 500

# constants
const SPEED = 100.0
const JUMP_VELOCITY = -250.0

var dead = false

# on ready, set camera limits
func _ready() -> void:
	camera.limit_bottom = cameraLimitBottom
	camera.limit_top = cameraLimitTop
	camera.limit_right = cameraLimitRight
	camera.limit_left = cameraLimitLeft

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and not dead:
		velocity += get_gravity() * delta
	elif not is_on_floor():
		velocity += get_gravity() / 2 * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and not Input.is_action_pressed("crouch") and not dead:
		#reset idle timer, move up, play a sound, and play an animation
		idleTimer.start()
		velocity.y = JUMP_VELOCITY
		jumpPlayer.play()
		sprite.play("jump")

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	
	# flip sprite depending on movement direction
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true
	
	# While a direction is held, move unless crouched
	if direction and not Input.is_action_pressed("crouch") and not dead:
		idleTimer.start()
		if Input.is_action_pressed("sprint"):
			velocity.x = direction * SPEED * 1.5
		else:
			velocity.x = direction * SPEED
	# If no direction is held, slow down and stop
	else:
		velocity.x = move_toward(velocity.x, 0, 10)
	
	# Animation tree
	if dead:
		pass
	elif Input.is_action_pressed("crouch"):
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


func _on_hit_box_body_entered(_body: Node2D) -> void:
	if not dead:
		velocity.y = (JUMP_VELOCITY / 2)
		gameOverPlayer.play()
		sprite.play("dead")
		sprite.modulate = Color(1, 0, 0)
		camera.position = position
		camera.top_level = true
		
	dead = true
	
	if not worldCollision == null:
		worldCollision.queue_free()
