extends CharacterBody2D

@export var deathParticle : PackedScene
@export var player_reference : CharacterBody2D
var speed : float
var damage : float
var health : float
const XP_GEM = preload("uid://dbe4inq0kgh0l")

var type : Enemy:
	set(value):
		type = value
		$Sprite2D.texture = value.texture
		health = value.health
		damage = value.damage
		speed = value.speed

func _physics_process(delta: float) -> void:
	velocity = (player_reference.position - position).normalized() * speed
	move_and_collide(velocity * delta)

func take_damage(amount):
	# Efeito de dano
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color(3, 0.25, 0.25), 0.2)
	tween.chain().tween_property($Sprite2D, "modulate", Color(1, 1, 1), 0.2)
	tween.bind_node(self)

	health -= amount # O dano em si
	if health <= 0:
		drop_xp()
		death_particles()
		notify_horde_manager()
		queue_free()

func notify_horde_manager():
	var horde_manager = get_tree().get_first_node_in_group("horde_manager")
	if horde_manager:
		horde_manager.enemy_died()

func death_particles():
	var _particle = deathParticle.instantiate()
	_particle.position = global_position
	_particle.rotation = global_rotation
	get_tree().current_scene.add_child(_particle)

func drop_xp():
	var xp_instance = XP_GEM.instantiate()
	get_parent().add_child(xp_instance)
	xp_instance.position = position
