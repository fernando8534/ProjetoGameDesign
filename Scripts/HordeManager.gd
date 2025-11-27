extends Node

signal wave_started(wave_number: int)
signal wave_ended(wave_number: int)
signal horde_incoming(seconds: int)
signal all_waves_complete()

@export var spawner: Node2D
@export var player: CharacterBody2D
@export var wave_label: Label
@export var warning_label: Label

var waves = [
	# Onda 1 - Onda tutorial
	{"enemies": [{"type": 1, "count": 15}], "break_time": 8.0, "name": "Primeiro Contato"},

	# Onda 2 - Inimigos mistos
	{"enemies": [{"type": 1, "count": 20}, {"type": 2, "count": 5}], "break_time": 8.0, "name": "Ameaça Crescente"},

	# Onda 3 - Mais pressão
	{"enemies": [{"type": 1, "count": 15}, {"type": 2, "count": 10}], "break_time": 7.0, "name": "O Enxame"},

	# Onda 4 - Inimigos mais fortes
	{"enemies": [{"type": 2, "count": 20}, {"type": 3, "count": 5}], "break_time": 7.0, "name": "Poder Crescente"},

	# Onda 5 - Desafio mid-game
	{"enemies": [{"type": 2, "count": 15}, {"type": 3, "count": 12}], "break_time": 6.0, "name": "Assalto Implacável"},

	# Onda 6 - Inimigos de alto nível
	{"enemies": [{"type": 2, "count": 10}, {"type": 3, "count": 15}, {"type": 4, "count": 8}], "break_time": 6.0, "name": "Forças de Elite"},

	# Onda 7 - Números massivos
	{"enemies": [{"type": 3, "count": 25}, {"type": 4, "count": 10}], "break_time": 5.0, "name": "A Horda"},

	# Onda 8 - Alta dificuldade
	{"enemies": [{"type": 3, "count": 20}, {"type": 4, "count": 15}], "break_time": 5.0, "name": "Chances Esmagadoras"},

	# Onda 9 - Quase o fim
	{"enemies": [{"type": 3, "count": 15}, {"type": 4, "count": 25}], "break_time": 5.0, "name": "Resistência Final"},

	# Onda 10 - Onda final
	{"enemies": [{"type": 4, "count": 50}], "break_time": 0.0, "name": "Apocalipse"},
]

var current_wave = 0
var is_wave_active = false
var enemies_remaining = 0
var is_break_time = false

func _ready() -> void:
	# Start first wave after a short delay
	await get_tree().create_timer(3.0).timeout
	start_wave()

func start_wave():
	if current_wave >= waves.size():
		# All waves completed!
		emit_signal("all_waves_complete")
		if wave_label:
			wave_label.text = "VITÓRIA! Todas as Ondas Concluídas!"
		return

	is_wave_active = true
	is_break_time = false
	var wave_data = waves[current_wave]

	if wave_label:
		wave_label.text = "Onda %d/%d - %s" % [current_wave + 1, waves.size(), wave_data["name"]]

	if warning_label:
		warning_label.text = "ONDA %d CHEGANDO!" % (current_wave + 1)
		warning_label.visible = true
		await get_tree().create_timer(2.0).timeout
		warning_label.visible = false

	emit_signal("wave_started", current_wave + 1)

	enemies_remaining = 0
	var speed_multiplier = 1.0 + (current_wave * 0.1)

	for enemy_group in wave_data["enemies"]:
		var enemy_type = enemy_group["type"]
		var count = enemy_group["count"]
		enemies_remaining += count
		spawner.spawn_wave(enemy_type, count, speed_multiplier)

	print("Onda %d iniciada: %d inimigos" % [current_wave + 1, enemies_remaining])

func enemy_died():
	if not is_wave_active:
		return

	enemies_remaining -= 1

	# Update UI with remaining enemies
	if wave_label:
		var wave_data = waves[current_wave]
		wave_label.text = "Onda %d/%d - %s (%d restantes)" % [
			current_wave + 1,
			waves.size(),
			wave_data["name"],
			enemies_remaining
		]

	if enemies_remaining <= 0:
		end_wave()

func end_wave():
	is_wave_active = false
	emit_signal("wave_ended", current_wave + 1)

	print("Onda %d concluída!" % (current_wave + 1))

	current_wave += 1

	if current_wave >= waves.size():
		emit_signal("all_waves_complete")
		if wave_label:
			wave_label.text = "VITÓRIA! Todas as Ondas Concluídas!"

		show_victory_screen()
		return

	is_break_time = true
	var break_duration = waves[current_wave - 1]["break_time"]

	if wave_label:
		wave_label.text = "Intervalo - Próxima onda em..."

	for i in range(int(break_duration), 0, -1):
		if warning_label:
			warning_label.text = "Próxima onda em %d segundos..." % i
			warning_label.visible = true
		await get_tree().create_timer(1.0).timeout

	if warning_label:
		warning_label.visible = false

	start_wave()

func get_current_wave_number() -> int:
	return current_wave + 1

func get_total_waves() -> int:
	return waves.size()

func is_in_break() -> bool:
	return is_break_time

func show_victory_screen():
	# Show game over screen as victory screen
	var game_over_screen = get_tree().get_first_node_in_group("game_over_screen")
	if not game_over_screen:
		game_over_screen = get_node_or_null("%GameOverScreen")

	if game_over_screen:
		# Update the label to show victory message
		var label = game_over_screen.get_node_or_null("ColorRect/Label")
		if label:
			label.text = "VITÓRIA!\nTodas as 10 Ondas Concluídas!"

		game_over_screen.visible = true
		get_tree().paused = true
