extends Node

func apply_health_upgrade(player):
	player.max_health *= 1.2
	player.get_node("Health").max_value *= 1.2
	
var all_upgrades := [
	{
		"name": "Aumento de Vida",
		"description": "+20% de HP",
		#"icon": preload("res://assets/upgrades/damage.png"),
		"apply": apply_health_upgrade
	},

	{
		"name": "Dash Mais Rápido",
		"description": "-25% cooldown do dash",
		#"icon": preload("res://assets/upgrades/dash.png"),
		"apply": func(player): player.dash_cooldown *= 0.75
	},

	{
		"name": "Velocidade de Movimento",
		"description": "+15% velocidade de movimento",
		#"icon": preload("res://assets/upgrades/speed.png"),
		"apply": func(player): player.speed *= 1.15
	},
]

#signal upgrades_selected(options)
#signal upgrade_chosen(upgrade)

func get_random_upgrades():
	var pool = all_upgrades.duplicate()
	pool.shuffle()
	return pool.slice(0, 3)
