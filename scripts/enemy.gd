extends CharacterBody2D

@export var player_ref : CharacterBody2D
var damage_popup_node = preload("res://scenes/damage.tscn")
var direction : Vector2
var speed : float = 150
var damage : float = 1
var knockback : Vector2
var health : float = 10 

func _ready() -> void:
	add_to_group("enemies")


func _process(delta: float) -> void:
	velocity = (player_ref.position - position).normalized() * speed
	knockback = knockback.move_toward(Vector2.ZERO, 1)
	velocity += knockback
	var collider = move_and_collide(velocity * delta)
	
	if collider:
		if collider.get_collider().has_method("knockback"):
			collider.get_collider().knockback = (collider.get_collider().global_position - global_position).normalized() * 50

func damage_popup(amount):
	var popup = damage_popup_node.instantiate()
	popup.text = str(amount)
	popup.position = position + Vector2(-50, -25)
	get_tree().current_scene.add_child(popup)

func take_damage(amount):
	health -= amount 
	
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color(3, 0.25, 0.25), 0.2)
	tween.chain().tween_property($Sprite2D, "modulate", Color(1, 1, 1), 0.2)
	tween.bind_node(self)
	
	damage_popup(amount)
	
	if health <= 0:
		queue_free()  
