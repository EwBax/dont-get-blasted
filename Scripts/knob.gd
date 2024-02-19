extends Sprite2D

@onready var parent = $".."

@export var max_length = 17
@export var deadzone = 3


var pressing = false


func _ready():
	# adjusting for scale of parent
	max_length *= parent.scale.x


func _process(delta):
	if pressing:
		# if the press is within the ring
		if get_global_mouse_position().distance_to(parent.global_position) <= max_length:
			global_position = get_global_mouse_position()
		else:
			var angle = parent.global_position.angle_to_point(get_global_mouse_position())
			global_position.x = parent.global_position.x + cos(angle) * max_length
			global_position.y = parent.global_position.y + sin(angle) * max_length
		calculate_vector()
	else:
		# smoothly return to center
		global_position = lerp(global_position, parent.global_position, delta * 10)
		parent.position_vector = Vector2.ZERO
	print(parent.position_vector)

func calculate_vector():
	if abs(global_position.x - parent.global_position.x) >= deadzone:
		# getting vector from -1 to 1
		parent.position_vector.x = (global_position.x - parent.global_position.x) / max_length
	if abs(global_position.y - parent.global_position.y) >= deadzone:
		parent.position_vector.y = (global_position.y - parent.global_position.y) / max_length


func _on_button_button_down():
	pressing = true


func _on_button_button_up():
	pressing = false
