extends RigidBody2D

var point_value = 5


# making asteroid disappear when it goes off screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("friendly"):
		get_tree().call_group("score_tracker", "add_points", point_value)
	destroy()


func destroy():
	hide()
	queue_free()
