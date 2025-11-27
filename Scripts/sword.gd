extends Area2D

var damage = 6
@onready var timer = $Timer
@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monitoring = false
	connect("body_entered", Callable(self, "_on_body_entered"))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
