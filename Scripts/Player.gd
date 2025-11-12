extends CharacterBody2D

@export var speed : float = 300
@export var dash_speed : float = 800
@export var dash_duration : float = 0.2
@export var dash_cooldown : float = 1.0

var is_dashing : bool = false
var can_dash : bool = true
var dash_timer : float = 0.0
var dash_direction : Vector2 = Vector2.ZERO

@onready var health_bar = %Health
@onready var collision = %Collision

var health : float = 100:
	set(value):
		health = clamp(value, 0, 100)
		health_bar.value = health

func _physics_process(delta: float) -> void:
	# Movimento normal
	if not is_dashing:
		var input_dir = Input.get_vector("left", "right", "up", "down")
		velocity = input_dir * speed
	else:
		# Durante o dash, move na direção do dash
		velocity = dash_direction * dash_speed
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			# Inicia cooldown
			$DashCooldown.start()

	move_and_slide()

	# Inicia o dash
	if Input.is_action_just_pressed("dash") and can_dash and not is_dashing:
		start_dash()


func start_dash() -> void:
	is_dashing = true
	can_dash = false
	dash_direction = Input.get_vector("left", "right", "up", "down")
	if dash_direction == Vector2.ZERO:
		# se o jogador não estiver apertando direção, dash pra frente
		dash_direction = velocity.normalized()
	dash_timer = dash_duration


func _on_dash_cooldown_timeout() -> void:
	can_dash = true


func take_damage(amount: float) -> void:
	health -= amount
	
	if health <= 0:
		_on_player_health_depleted()


func _on_area_2d_body_entered(body: Node2D) -> void:
	take_damage(body.damage)

func _on_player_health_depleted():
	%GameOverScreen.visible = true
	get_tree().paused = true
