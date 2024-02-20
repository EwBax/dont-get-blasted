extends CharacterBody2D

signal game_over()
signal hp_updated(hit_points)

@export var laser_bolt_scene : PackedScene
@export var speed = 150
@export var laser_speed = 300
@export var hit_point_maximum = 3
@export var joystick: Joystick
@export var fire_button: TouchScreenButton

var hit_points = hit_point_maximum
var screen_size
var input_velocity = Vector2.ZERO
var pixel_offset = 8


func _ready():
	# getting the screen size for player bounds
	screen_size = get_viewport_rect().size
	hide()


func start(pos):
	hit_points = hit_point_maximum
	$AnimatedSprite2D.play("fly")
	hp_updated.emit(hit_points)
	position = pos
	show()


func _process(delta):
	
	#===============KEYBOARD / GAMEPAD CONTROLS=====================
	## checking for player input
	#if Input.is_action_pressed("move_up"):
		#input_velocity.y -= 1
	#if Input.is_action_pressed("move_down"):
		#input_velocity.y += 1
	#if Input.is_action_pressed("move_right"):
		#input_velocity.x += 1
	#if Input.is_action_pressed("move_left"):
		#input_velocity.x -= 1
	#if Input.is_action_pressed("primary_fire") and $LaserFireRate.is_stopped():
		#fire_laser()
	#=================================================================
	
	input_velocity = joystick.position_vector
	
	if fire_button.is_pressed() and $LaserFireRate.is_stopped():
		fire_laser()
	
	# checking what animation to play
	if input_velocity.y < 0:
		$AnimatedSprite2D.play("bank_port")
	elif input_velocity.y > 0:
		$AnimatedSprite2D.play("bank_starboard")
	else:
		$AnimatedSprite2D.play("fly")
	
	if input_velocity.length() > 0:
		input_velocity = input_velocity.normalized() * speed


func _physics_process(delta):
	
	#updating the player's position on screen
	move_and_collide(input_velocity * delta)
	
	position = position.clamp(Vector2(pixel_offset, pixel_offset), Vector2(screen_size.x - pixel_offset, screen_size.y - pixel_offset))


# player hit by enemy or object
func _on_body_entered(body):
	
	hit_points -= 1
	hp_updated.emit(hit_points)
	if hit_points <= 0:
		game_over.emit()
		hide()


func fire_laser():
	
	var laser_bolt = laser_bolt_scene.instantiate()
	
	var fire_position = $ProjectileFirePosition.position
	
	laser_bolt.position = fire_position
	laser_bolt.linear_velocity = Vector2(laser_speed, 0)
	
	add_child(laser_bolt)
	
	$LaserFireRate.start()
	$LaserSound.play()
