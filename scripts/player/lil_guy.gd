extends Character

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("swap character") and PlayerManager._character == 1 and PlayerManager.can_swap:
		PlayerManager.set_character(2)
	if PlayerManager._character == 1:
		camera.make_current()
		
	determine_animation()

func _physics_process(delta: float) -> void:
	if PlayerManager._character == 1:
		process_input()
		handle_jump()
	handle_gravity(delta)
