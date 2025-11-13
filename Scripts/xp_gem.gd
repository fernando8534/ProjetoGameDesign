extends Area2D

var is_collected = false
var game_manager: Node
@onready var pickup_sound: AudioStreamPlayer2D = $PickupSound
@onready var timer: Timer = $Timer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	_get_game_manager()

func _on_body_entered(body: Node2D) -> void:
	if is_collected or not body.is_in_group("player"):
		return
	is_collected = true

	game_manager.add_xp(1)
	pickup_sound.play()
	animated_sprite_2d.visible = false
	collision_shape_2d.disabled = true
	timer.start()
	
func _get_game_manager():
	game_manager = get_tree().get_first_node_in_group("game_manager")

func _on_timer_timeout() -> void:
	queue_free()
