extends RigidBody2D

var point_value = 5


# making asteroid disappear when it goes off screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	destroy()


func destroy():
	hide()
	queue_free()
