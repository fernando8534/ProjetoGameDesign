extends Area2D

const SPEED: int = 500
const DAMAGE: float = 4
#var already_hit: bool = false ; usado caso queira ter penetração limitada

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * SPEED * delta

func _on_body_entered(body):
	# Os comentados servem para penetração limitada
	#if already_hit:
	#	return
	
	if body.has_method("take_damage"):
		body.take_damage(DAMAGE)
	#already_hit = true
	#queue_free()


func _on_screen_exited():
	queue_free()
