extends CharacterBody2D

signal game_over()
signal hp_updated(hit_points)

@export var laser_bolt_scene : PackedScene
@export var speed = 200
@export var laser_speed = 300
@export var hit_point_maximum = 3
var hit_points = hit_point_maximum
var screen_size


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
	if Input.is_action_pressed("primary_fire") and $LaserFireRate.is_stopped():
		fire_laser()


func _physics_process(delta):
	# the player's velocity
	var velocity = Vector2.ZERO
	
	# checking for player input
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	
	
	# checking what animation to play
	if velocity.y < 0:
		$AnimatedSprite2D.play("bank_port")
	elif velocity.y > 0:
		$AnimatedSprite2D.play("bank_starboard")
	else:
		$AnimatedSprite2D.play("fly")
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	#updating the player's position on screen
	move_and_collide(velocity * delta)
	
	position = position.clamp(Vector2.ZERO, screen_size)


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
