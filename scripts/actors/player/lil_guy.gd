extends Player

var _id = 1
var _alt_id = 2

func _process(delta: float) -> void:
	# 1 = lil guy, 2 = sir helmet
	if Input.is_action_just_pressed("swap character") and PlayerManager._character == _id and PlayerManager.can_swap:
		PlayerManager.set_character(_alt_id)
	if dead and PlayerManager.can_swap:
		PlayerManager.set_character(_alt_id)
	
	determine_animation()

func _physics_process(delta: float) -> void:
	super(delta)
	if PlayerManager._character == _id:
		process_input()
