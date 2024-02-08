extends Node


@export var asteroid_scene: PackedScene
var score

# spawns a new asteroid on timeout
func _on_asteroid_timer_timeout():
	
	# instantiating a new asteroid
	var asteroid = asteroid_scene.instantiate()
	
	# choosing a random location on the spawn path
	var asteroid_spawn_location = $AsteroidSpawnPath/AsteroidSpawnLocation
	asteroid_spawn_location.progress_ratio = randf()
	
	# setting the direction perpendicular to the spawn path
	var direction = asteroid_spawn_location.rotation + PI / 2
	# adding some randomness
	direction += randf_range(-PI / 4, PI / 4)
	
	# setting the position and directoin of the asteroid
	asteroid.position = asteroid_spawn_location.position
	asteroid.rotation = direction
	
	# Choose the velocity for the asteroid
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	asteroid.linear_velocity = velocity.rotated(direction)
	
	# spawning the asteroid
	add_child(asteroid)


func _on_player_hp_updated(hit_points):
	$HUD.update_health_bar(hit_points)


func new_game():
	score = 0
	$HUD.update_score(score)
	$HUD.update_health_bar($Player.hit_points)
	$Player.start($PlayerStartLocation.position)
	$StartTimer.start()


func _on_start_timer_timeout():
	$AsteroidTimer.start()
