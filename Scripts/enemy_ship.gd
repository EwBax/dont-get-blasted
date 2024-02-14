extends CharacterBody2D

@export var laser_bolt_scene : PackedScene
@export var laser_speed = 300
@export var max_move_distance = 40
@export var min_move_distance = 10
@export var speed = 50
@export var point_value = 15
@export var hit_point_maximum = 2
var hit_points = hit_point_maximum
var screen_size
# the farthest left on the screen that the enemy will go
var x_min
var target_position

func _ready():
	# getting the screen size for player bounds
	screen_size = get_viewport_rect().size
	# limiting enemy to rightmost third of screen
	x_min = screen_size.x * .67


func start(start_position):
	position = start_position
	target_position = Vector2(position.x - 15, position.y)


func _on_body_entered(body):
	if body.is_in_group("friendly"):
		hit_points -= 1
		# make some kind of visual indication that it was hit
		if hit_points == 0:
			get_tree().call_group("score_tracker", "add_points", point_value)
			destroy()


# picks a random direction to move in, making sure not to go off screen
func get_random_position():
	
	var position = Vector2(-1, -1)
	
	# Picking a random target distance
	while target_position.x < x_min || target_position.x > screen_size.x || target_position.y < 0 || target_position.y > screen_size.y:
		target_position = Vector2(randi_range(min_move_distance, max_move_distance + 1), 0)
		# rotating the position randomly
		target_position = target_position.rotated(randf() * 2 * PI)
		
	return position


func move_to_position(position):
	target_position = position


func destroy():
	hide()
	queue_free()
