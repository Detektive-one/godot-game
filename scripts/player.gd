extends CharacterBody2D

signal player_died
const move_speed = 400
var destination = Vector2()
var click = Vector2()
var health : float = 100:
	set(value):
		health = value
		%Health.value = value 

@export var projectile_scene: PackedScene
var can_shoot = true
@onready var cooldown_timer = $CooldownTimer
@export var initial_position: Vector2 = Vector2(500,300)

func _ready():
	click = position

func reset():
	health = 100
	position = initial_position
	click = position
	
	can_shoot = true

func _physics_process(delta):
	if Input.is_action_just_pressed("movement"):
		click = get_global_mouse_position()
	
	if position.distance_to(click) > 3:
		destination = (click - position).normalized()
		velocity = destination * move_speed
		move_and_slide()
	
	if Input.is_action_just_pressed("shoot") and can_shoot:
		shoot()

func shoot():
	var projectile = projectile_scene.instantiate()
	projectile.position = position
	projectile.direction = (get_global_mouse_position() - position).normalized()
	get_parent().add_child(projectile)
	can_shoot = false
	cooldown_timer.start()

func take_damage(amount):
	health -= amount
	%Health.value = health
	if health <= 0:
		emit_signal("player_died")

func _on_self_damage_body_entered(body: Node2D) -> void:
	take_damage(body.damage)

func _on_timer_timeout() -> void:
	%Collision.set_deferred("disabled", true)
	%Collision.set_deferred("disabled", false)

func _on_cooldown_timer_timeout():
	can_shoot = true


func _on_player_died() -> void:
	var game_manager = get_node("/root/test/GameManager")
	game_manager.end_game()
