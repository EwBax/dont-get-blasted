extends RigidBody2D


# making asteroid disappear when it goes off screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
