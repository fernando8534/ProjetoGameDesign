extends Node2D

@export var player : CharacterBody2D
@export var enemy : PackedScene

# Enemy type resources
var enemy_types = [
	preload("res://Resources/Slime1.tres"),
	preload("res://Resources/Slime2.tres"),
	preload("res://Resources/Slime3.tres"),
	preload("res://Resources/Slime4.tres")
]

var distance : float = 1000

var minute : int:
	set(value):
		minute = value
		%Minute.text = str(value)

var second : int:
	set(value):
		second = value
		if second >= 60:
			second -= 60
			minute += 1
		%Second.text = str(second).lpad(2,'0')


func spawn(pos : Vector2, enemy_type: Enemy = null):
	var enemy_instance = enemy.instantiate()
	enemy_instance.position = pos
	enemy_instance.player_reference = player

	if enemy_type:
		enemy_instance.type = enemy_type

	get_tree().current_scene.add_child(enemy_instance)

func get_random_position() -> Vector2:
	return player.position + distance * Vector2.RIGHT.rotated(randf_range(0, 2 * PI))

func amount(number : int = 1):
	for i in range(number):
		spawn(get_random_position())

func spawn_wave(type_index: int, count: int):
	var enemy_type_resource = enemy_types[type_index - 1] if type_index > 0 and type_index <= enemy_types.size() else enemy_types[0]

	for i in range(count):
		var spawn_pos = get_random_position()
		spawn(spawn_pos, enemy_type_resource)

		if i % 5 == 0:
			await get_tree().create_timer(0.1).timeout

func _on_timer_3_timeout() -> void:
	second += 1
