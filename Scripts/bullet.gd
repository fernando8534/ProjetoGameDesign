extends Area2D

@export var PEN: int = 2
@export var SPEED: int = 500
@export var DAMAGE: float = 4
@export var already_hit: bool = false 

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	position += transform.x * SPEED * delta

func _on_body_entered(body):
	PEN -= 1
	if already_hit:
		return
	
	if body.has_method("take_damage"):
		body.take_damage(DAMAGE)
	
	if PEN == 0:
		already_hit = true
		queue_free()


func _on_screen_exited():
	queue_free()
