extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D


const SPEED = 150.0
const JUMP_VELOCITY = -250.0

var direction = 0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true
		
	sprite.play("idle")

	move_and_slide()
