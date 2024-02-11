extends RigidBody2D


@export var max_move_distance = 50
@export var point_value = 15
@export var hit_point_maximum = 2
var hit_points = hit_point_maximum
var screen_size
# the farthest left on the screen that the enemy will go
var x_min

func _ready():
	# getting the screen size for player bounds
	screen_size = get_viewport_rect().size
	# limiting enemy to rightmost third of screen
	x_min = screen_size.x * .67

func _on_body_entered(body):
	if body.is_in_group("friendly"):
		hit_points -= 1
		# make some kind of visual indication that it was hit
		if hit_points == 0:
			get_tree().call_group("score_tracker", "add_points", point_value)
			destroy()


# picks a random direction to move in, making sure not to go off screen
func random_direction():
	
	

