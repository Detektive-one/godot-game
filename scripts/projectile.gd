extends Area2D

var direction = Vector2.RIGHT
var dmg = 5
var speed : float = 200 

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(dmg)

func _on_screen_exited() -> void:
	queue_free()
