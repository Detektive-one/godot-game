extends Control

@onready var message_label = $MessageLabel
@onready var score_label = $ScoreLabel
@onready var timer_label = $TimerLabel
@onready var start_button = $StartButton


func _ready():
	start_button.connect("pressed", Callable(self, "_on_start_button_pressed"))


func show_message(text, duration = 0):
	message_label.text = text
	message_label.show()
	if duration > 0:
		get_tree().create_timer(duration).connect("timeout", Callable(self, "hide_message"))

func hide_message():
	message_label.hide()

func update_score(score):
	score_label.text = "Score: " + str(int(score))

func update_timer(minutes, seconds):
	timer_label.text = str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)

func _on_start_button_pressed():
	get_node("/root/test/GameManager").start_game()
