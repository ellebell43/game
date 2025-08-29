extends Camera2D
# 1 = lil guy, 2 = sir helmet

@export var subject1: Node = null
@export var subject2: Node = null

var active = PlayerManager._character
var move: bool = true
var snap_to: bool = false

const SPEED: int = 100
const SNAP_SPEED: int = 300

func _process(delta: float) -> void:
	if not active == PlayerManager._character:
		snap_to = true
		move = true
	else:
		snap_to = false
	# Follow subject if allowed to move
	if not (subject1.dead and subject2.dead) and move:
		match PlayerManager._character:
			1:
				# lil guy
				if not subject1 == null and not position == subject1.position and not snap_to:
					position += position.direction_to(subject1.position) * SPEED * delta
				if not subject1 == null and not position == subject1.position and snap_to:
					position += position.direction_to(subject1.position) * SNAP_SPEED * delta
			2:
				# sir helmet
				if not subject2 == null and not position == subject1.position and not snap_to:
					position += position.direction_to(subject2.position) * SPEED * delta
				if not subject1 == null and not position == subject1.position and snap_to:
					position += position.direction_to(subject2.position) * SNAP_SPEED * delta
					
# Don't move if subject is in focus
func _on_focus_zone_body_entered(body: Node2D) -> void:
	match PlayerManager._character:
		1:
			if body._id == 1:
				active = 1
				move = false
		2: 
			if body._id == 2:
				active = 2
				move = false

# Allow move if subject is out of focus
func _on_focus_zone_body_exited(body: Node2D) -> void:
	match PlayerManager._character:
		1:
			if body._id == 1:
				move = true
		2: 
			if body._id == 2:
				move = true
