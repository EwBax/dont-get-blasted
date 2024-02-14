extends Node


@export var asteroid_scene: PackedScene
@export var enemy_ship_scene: PackedScene
var score


func _ready():
	$HUD.hide()


# spawns a new asteroid on timeout
func _on_asteroid_timer_timeout():
	
	# instantiating a new asteroid
	var asteroid = asteroid_scene.instantiate()
	
	# choosing a random location on the spawn path
	var asteroid_spawn_location = $MobSpawnPath/MobSpawnLocation
	asteroid_spawn_location.progress_ratio = randf()
	
	# setting the direction perpendicular to the spawn path
	var direction = asteroid_spawn_location.rotation + PI / 2
	# adding some randomness
	direction += randf_range(-PI / 8, PI / 8)
	
	# setting the position and directoin of the asteroid
	asteroid.position = asteroid_spawn_location.position
	asteroid.rotation = direction
	
	# Choose the velocity for the asteroid
	var velocity = Vector2(randf_range(150.0, 200.0), 0.0)
	asteroid.linear_velocity = velocity.rotated(direction)
	
	# spawning the asteroid
	add_child(asteroid)


func game_over():
	$AsteroidTimer.stop()
	$EnemyShipTimer.stop()
	$Player.hide()
	$Menu.show()


func add_points(points):
	score += points
	$HUD.update_score(score)


func _on_player_hp_updated(hit_points):
	$HUD.update_health_bar(hit_points)
	if hit_points == 0:
		game_over()


func new_game():
	$HUD.show()
	score = 0
	$Player.start($PlayerStartLocation.position)
	$HUD.update_score(score)
	$HUD.update_health_bar($Player.hit_points)
	$StartTimer.start()


func _on_start_timer_timeout():
	$AsteroidTimer.start()
	$EnemyShipTimer.start()


func _on_enemy_ship_timer_timeout():
	var enemy_ship = enemy_ship_scene.instantiate()
	
	# choosing a random location on the spawn path
	var ship_spawn_location = $MobSpawnPath/MobSpawnLocation
	ship_spawn_location.progress_ratio = randf()
	
	enemy_ship.start(ship_spawn_location.position)
	add_child(enemy_ship)
