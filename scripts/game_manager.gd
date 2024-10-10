extends Node

signal game_started
signal game_ended
signal game_paused
signal game_resumed

var is_game_active = false
var is_game_paused = false
var score = 0

@onready var player = $"../Player"  # Adjust the path to your player node
@onready var spawner = $"../Spawner"  # Adjust the path to your spawner node
@onready var ui = $"../UI/Control"  # Adjust the path to your UI node

func _ready():
	pass

func start_game():
	is_game_active = true
	score = 0
	player.reset()
	clear_enemies()
	spawner.start_spawning()
	ui.show_message("Game Started!", 1)  # Show for 2 seconds
	ui.update_score(score)
	emit_signal("game_started")

func end_game():
	is_game_active = false
	spawner.stop_spawning()
	ui.show_message("Game Over! Score: " + str(int(score)), 5)
	emit_signal("game_ended")

	var window = JavaScriptBridge.get_interface("window")
	if window != null:
		JavaScriptBridge.eval("if (typeof onGameEnd === 'function') { onGameEnd(" + str(int(score)) + "); }")

func pause_game():
	if is_game_active and not is_game_paused:
		is_game_paused = true
		get_tree().paused = true
		ui.show_message("Game Paused")
		emit_signal("game_paused")

func resume_game():
	if is_game_active and is_game_paused:
		is_game_paused = false
		get_tree().paused = false
		ui.hide_message()
		emit_signal("game_resumed")

func restart_game():
	end_game()
	start_game()

func _on_player_died():
	end_game()

func _process(delta):
	if is_game_active:
		score += delta
		ui.update_score(score)

		
func clear_enemies():
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()
