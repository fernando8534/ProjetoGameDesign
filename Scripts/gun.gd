extends Node2D

@export var BULLET : PackedScene = preload("res://Scenes/bullet.tscn")

var player
var player_pen
var player_damage
var timer

func _ready() -> void:
	player = get_parent()

	timer = Timer.new()
	timer.wait_time = 1
	timer.autostart = true
	timer.one_shot = false
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)


func _process(delta: float) -> void:
	player_damage = player.damage
	player_pen = player.pen
	timer.wait_time = player.hit_speed

	look_at(get_global_mouse_position())


func _on_timer_timeout() -> void:
	var bullet_instance = BULLET.instantiate()
	bullet_instance.DAMAGE *= player_damage
	bullet_instance.PEN = player_pen
	get_tree().root.add_child(bullet_instance)
	bullet_instance.global_position = global_position
	bullet_instance.rotation = rotation
