extends CharacterBody2D

@export var laser_bolt_scene : PackedScene
@export var laser_speed = 125
@export var max_move_distance = 80
@export var min_move_distance = 30
@export var speed = 50
@export var point_value = 15
@export var hit_point_maximum = 3

var pixel_offset = 8

var hit_points
var screen_size
# the farthest left on the screen that the enemy will go
var x_min
var target_position
var moving = false

func _ready():
	# getting the screen size for player bounds
	screen_size = get_viewport_rect().size
	# limiting enemy to rightmost third of screen
	x_min = screen_size.x * 0.5
	target_position = position


func _physics_process(delta):
	
	if position != target_position and moving:
		var distance = position.distance_to(target_position)
		
		var direction = (target_position - position)
		var new_velocity
		
		if distance <= speed * delta:
			new_velocity = direction
			$AnimatedSprite2D.play("fly")
		else:
			new_velocity = direction.normalized() * speed * delta
			if new_velocity.y < 0:
				$AnimatedSprite2D.play("bank_starboard")
			elif new_velocity.y > 0:
				$AnimatedSprite2D.play("bank_port")
			else:
				$AnimatedSprite2D.play("fly")
		
		move_and_collide(new_velocity)
		
	elif $MoveTimer.is_stopped() and moving:
		$MoveTimer.start()


func start(start_position):
	hit_points = hit_point_maximum
	position = start_position
	#target_position = Vector2(position.x - 30, position.y)
	random_target_position()
	moving = true
	$LaserTimer.start()


func _on_area_2d_body_entered(body):
	if body.is_in_group("friendly"):
		hit_points -= 1
		# make some kind of visual indication that it was hit
		if hit_points == 0:
			get_tree().call_group("score_tracker", "add_points", point_value)
			destroy()


# picks a random direction to move in, making sure not to go off screen
func random_target_position():
	
	# Starting with arbitrary out of range value
	var random_position = Vector2(-1, -1)
	
	# make sure it is in bounds
	while (random_position.x < (x_min + pixel_offset)) \
	  or (random_position.x >= (screen_size.x - pixel_offset)) \
	  or (random_position.y <= (0 + pixel_offset)) \
	  or (random_position.y >= (screen_size.y - pixel_offset)) \
	  or (random_position.distance_to(position) < min_move_distance):
		
		var random_offset = Vector2(randf_range(-max_move_distance, max_move_distance),
								 randf_range(-max_move_distance, max_move_distance))
		random_position = position + random_offset
	
	target_position = random_position


func destroy():
	hide()
	queue_free()


#func game_over():
	#moving = true
	#speed = 400
	#target_position = Vector2(-10, position.y)
	#$MoveTimer.stop()

func _on_laser_timer_timeout():
	# Don't want to shoot if moving
	if $MoveTimer.is_stopped():
		return
		
	var laser = laser_bolt_scene.instantiate()
	
	laser.position = Vector2(position.x - pixel_offset, position.y)
	laser.linear_velocity = Vector2(-laser_speed, 0)
	
	var parent = get_parent()
	parent.add_child(laser)
	$LaserSound.play()
