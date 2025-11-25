extends CharacterBody2D

@export var speed : float = 300
@export var dash_speed : float = 800
@export var dash_duration : float = 0.2
@export var dash_cooldown : float = 2.0

@onready var animated_sprite = $AnimatedSprite2D

var is_dashing : bool = false
var can_dash : bool = true
var dash_timer : float = 0.0
var dash_direction : Vector2 = Vector2.ZERO

@onready var health_bar = %Health
@onready var collision = %Collision

var max_health : float = 100

var health : float = max_health:
	set(value):
		health = clamp(value, 0, max_health)
		health_bar.value = health

func _physics_process(delta: float) -> void:
	# Movimento normal
	if not is_dashing:
		var input_dir = Input.get_vector("left", "right", "up", "down")
		velocity = input_dir * speed
		
		if input_dir.x < 0:
			animated_sprite.flip_h = true
		elif input_dir.x > 0:
			animated_sprite.flip_h = false
		
		if input_dir != Vector2.ZERO:
			if animated_sprite.animation != "default":
				animated_sprite.play("default")
		else:
			if animated_sprite.animation != "idle":
				animated_sprite.play("idle")
	else:
		# Durante o dash, move na direção do dash
		animated_sprite.play("dash")
		velocity = dash_direction * dash_speed
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			# Atualiza o valor do cooldown, caso tenha mudado, e o inicia
			$DashCooldown.wait_time = dash_cooldown
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
	if not is_dashing:
		health -= amount
	
	if health <= 0:
		_on_player_health_depleted()

func _on_area_2d_body_entered(body: Node2D) -> void:
	take_damage(body.damage)

func _on_player_health_depleted():
	%GameOverScreen.visible = true
	get_tree().paused = true

func restore_max_health():
	health = max_health
