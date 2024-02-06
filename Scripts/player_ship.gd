extends Area2D

signal hit(hit_points)

@export var speed = 200
@export var hit_points = 3
var screen_size


func _ready():
	# getting the screen size for player bounds
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.play("fly")


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


func _process(delta):
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
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)


# player hit by enemy or object
func _on_body_entered(body):
	hit_points -= 1
	if hit_points <= 0:
		hide()
		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", true)
	hit.emit(hit_points)
