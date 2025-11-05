extends Node2D

@export var BULLET : PackedScene = preload("res://Scenes/bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var timer = Timer.new()
	timer.wait_time = 1.0
	timer.autostart = true
	timer.one_shot = false
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())


func _on_timer_timeout() -> void:
	var bullet_instance = BULLET.instantiate()
	get_tree().root.add_child(bullet_instance)
	bullet_instance.global_position = global_position
	bullet_instance.rotation = rotation
