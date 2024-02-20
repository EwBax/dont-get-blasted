extends Sprite2D

@onready var parent = $".."

@export var max_length = 27
@export var deadzone = 3


var pressing = false
var pixel_offset = 26


func _ready():
	# adjusting for scale of parent
	max_length *= parent.scale.x


func _process(delta):
	var center = Vector2(parent.global_position.x + pixel_offset, parent.global_position.y + pixel_offset)
	if pressing:
		# if the press is within the ring
		if get_global_mouse_position().distance_to(center) <= max_length:
			global_position = get_global_mouse_position()
		else:
			var angle = center.angle_to_point(get_global_mouse_position())
			global_position.x = center.x + cos(angle) * max_length
			global_position.y = center.y + sin(angle) * max_length
		calculate_vector()
	else:
		# smoothly return to center
		global_position = lerp(global_position, center, delta * 10)
		parent.position_vector = Vector2.ZERO

func calculate_vector():
	var center = Vector2(parent.global_position.x + pixel_offset, parent.global_position.y + pixel_offset)
	if abs(global_position.x - center.x) >= deadzone:
		# getting vector from -1 to 1
		parent.position_vector.x = (global_position.x - center.x) / max_length
	if abs(global_position.y - center.y) >= deadzone:
		parent.position_vector.y = (global_position.y - center.y) / max_length


func _on_joystick_pressed():
	pressing = true


func _on_joystick_released():
	pressing = false
