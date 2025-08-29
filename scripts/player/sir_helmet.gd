extends Character

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("swap character") and PlayerManager._character == 2 and PlayerManager.can_swap:
		PlayerManager.set_character(1)
	if PlayerManager._character == 2:
		camera.make_current()
		
	determine_animation()

func _physics_process(delta: float) -> void:
	if PlayerManager._character == 2:
		process_input()
		handle_jump()
	handle_gravity(delta)
