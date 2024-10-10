extends Node2D

@export var player : CharacterBody2D
@export var enemy : PackedScene
var distance : float = 400
var minute : int:
	set(value):
		minute = value
		
var second : int:
	set(value):
		second = value
		if second >= 60:
			second -= 60
			minute += 1
		

var current_wave : int = 0
var enemies_per_wave : int = 5

func _ready() -> void:	
	start_spawning()

func start_spawning():	
	$WaveTimer.start()
	spawn_wave()  

func stop_spawning():
	$WaveTimer.stop()
	current_wave = 0
	enemies_per_wave = 5
	get_tree().call_group("enemies", "queue_free")

func spawn(pos : Vector2, elite : bool = false):
	var enemy_instance = enemy.instantiate()
	enemy_instance.position = pos
	enemy_instance.player_ref = player    
	get_tree().current_scene.add_child(enemy_instance)
 
func get_random_position() -> Vector2:
	return player.position + distance * Vector2.RIGHT.rotated(randf_range(0, 2 * PI))
 
func spawn_wave():
	for i in range(enemies_per_wave):
		spawn(get_random_position())
	
	current_wave += 1
	enemies_per_wave += 2  
	
func _on_timer_timeout() -> void:
	second += 1
	get_node("/root/test/UI/Control").update_timer(minute, second)

func _on_wave_timer_timeout() -> void:
	spawn_wave()
