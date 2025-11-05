extends Area2D

const SPEED: int = 300
const DAMAGE: int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * SPEED * delta

func _on_body_entered(body):
		body.take_damage(DAMAGE)
		print(DAMAGE)


func _on_screen_exited():
	queue_free()
