class_name CoOpManager
extends Control

var player_two_input_device: int
var allow_second_player := false

func _ready():
	var joypads = Input.get_connected_joypads()
	for id in joypads:
		print(Input.get_joy_name(id))
		
func _input(event: InputEvent) -> void:
	print("event detected from " + Input.get_joy_name(event.device))
