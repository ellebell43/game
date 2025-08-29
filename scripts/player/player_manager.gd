extends Node

# 1 = lil guy, 2 = sir helmet
var _character = 1
var _cooldown = Timer.new()
var can_swap = false

func _ready() -> void:
	_cooldown.one_shot = true
	add_child(_cooldown)

func set_character(num):
	if _cooldown.is_stopped():
		_character = num
		_cooldown.start(5)
	
