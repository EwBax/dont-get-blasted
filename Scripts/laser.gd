extends RigidBody2D


func on_screen_exited():
	queue_free()


func _on_body_entered(body):
	hide()
	queue_free()
