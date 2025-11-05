extends CharacterBody2D

@export var player_reference : CharacterBody2D
var speed : float = 75
var damage : float
var health : float:
	set(value):
		health = value
		if health <= 0:
			queue_free()

var type : Enemy:
	set(value):
		type = value
		$Sprite2D.texture = value.texture
		damage = value.damage
		
func _physics_process(delta: float) -> void:
	velocity = (player_reference.position - position).normalized() * speed
	move_and_collide(velocity * delta)

func take_damage(amount):
	health -= amount
	print(amount)
