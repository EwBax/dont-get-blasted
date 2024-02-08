extends CanvasLayer


func update_health_bar(hit_points):
	$HealthBar.value = hit_points


func update_score(score):
	$Score.text = str(score)


func show_message(message):
	$Message.text = message
	$MessageTimer.start()


func _on_message_timer_timeout():
	$Message.text = ""
