extends CharacterBody2D

var speed : float = 300
var damage: float = 0
var health : float = 100:
	set(value):
		health = value
		%Health.value = value

func _physics_process(delta: float) -> void:
	velocity = Input.get_vector("left", "right", "up", "down") * speed
	move_and_collide(velocity * delta)

func take_damage(amount):
	health -= amount
	print(amount)

func _on_area_2d_body_entered(body: Node2D) -> void:
	take_damage(body.damage) #Quando o inimigo colidir com o player, reduz a vida com o dano que o inimigo tem


func _on_timer_timeout() -> void:
	%Collision.set_deferred("disabled", true)
	%Collision.set_deferred("disabled", false)
