extends CharacterBody2D
class_name Player

# REQUIRED ANIMATIONS FOR A PLAYER
# - dead
# - crouch
# - walk
# - run
# - idle
# - stand

# node references
@onready var jump_audio = $JumpAudio
@onready var idle_timer = $IdleTimer
@onready var game_over_audio = $GameOverAudio
# comes from child, set by user
@export var sprite: AnimatedSprite2D = null

# movement properites
@export var speed: float = 100.0
@export var jump_velocity: float = -250.0

# management variables
var dead: bool = false
var idle_time: int = randi_range(5, 15)

func get_rand_idle():
	return randi_range(5,15)
	
func _physics_process(delta: float) -> void:
	# Fall if not on ground, fall slow if dead
	if not is_on_floor() and not dead:
		velocity += get_gravity() * delta
	elif not is_on_floor():
		velocity += get_gravity() / 2 * delta
	
	# Slow down and stop
	velocity.x = move_toward(velocity.x, 0, 10)
	
	move_and_slide()
	
func process_input():
	if Input.is_action_just_pressed("menu"):
		get_tree().reload_current_scene()
	if not dead:
		# Get the input direction and handle the movement/deceleration.
		var direction := Input.get_axis("left", "right")
		
		# flip sprite depending on movement direction
		if not sprite == null:
			if direction > 0:
				sprite.flip_h = false
			elif direction < 0:
				sprite.flip_h = true
		
		# While a direction is held, reset idle timer and move unless crouched
		if direction and not Input.is_action_pressed("crouch"):
			self.idle_timer.start(get_rand_idle())
			if Input.is_action_pressed("sprint"):
				velocity.x = direction * speed * 1.5
			else:
				velocity.x = direction * speed
		
		if Input.is_action_just_pressed("jump") and is_on_floor() and not Input.is_action_pressed("crouch"):
			#reset idle timer, move up, play a sound, and play an animation
			idle_timer.start(get_rand_idle())
			velocity.y = jump_velocity
			jump_audio.play()
			sprite.play("jump")
	

func determine_animation():
	if not sprite == null:
		if dead:
			sprite.play("dead")
		elif Input.is_action_pressed("crouch"):
			sprite.play("crouch")
		elif velocity.x != 0 and velocity.y == 0:
			if Input.is_action_pressed("sprint"):
				sprite.play("walk")
			else:
				sprite.play("run")
		elif velocity.x == 0 and velocity.y == 0 and idle_timer.is_stopped():
			sprite.play("idle")
		elif velocity.x == 0 and velocity.y == 0:
			sprite.play("stand")
		elif velocity.y > 250:
			sprite.play("fall")


func _on_hit_box_body_entered(_body: Node2D) -> void:
	if not dead:
		# jump up, turn red, play game over audio, stop moving the camera, and disabled world collision to allow player to fall out of frame
		velocity.y = (jump_velocity / 2)
		game_over_audio.play()
		if sprite:
			sprite.modulate = Color(1, 0, 0)
		
		for node in get_children():
			if node is CollisionShape2D:
				node.set_deferred("disabled", true)
			if node is Area2D:
				node.set_deferred("monitoring", false)
		
		# Set dead to true so that code doesn't re-run
		dead = true
