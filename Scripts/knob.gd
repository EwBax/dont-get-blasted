extends Sprite2D

@onready var parent = $".."

@export var max_length = 17
@export var deadzone = 2


var pressing = false


func _process(delta):
	if pressing:
		if get_global_mouse_position().distance_to(parent.global_position) <= max_length:
			global_position = get_global_mouse_position()
	else:
		global_position = lerp(global_position, parent.global_position, delta * 10)


func _on_button_button_down():
	pressing = true


func _on_button_button_up():
	pressing = false
