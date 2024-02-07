extends RigidBody2D


func on_screen_exited():
	queue_free()
