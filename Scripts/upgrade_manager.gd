extends Node

func apply_health_upgrade(player):
	player.max_health *= 1.2
	player.get_node("Health").max_value *= 1.2
	
var all_upgrades := [
	{
		"name": "Colete Resistente",
		"description": "+20% de HP",
		"icon": preload("res://Icons/coleteupgrade.png"),
		"apply": apply_health_upgrade
	},

	{
		"name": "Botas Novas",
		"description": "+15% velocidade de movimento" ,
		"icon": preload("res://Icons/botasupgrade.png"),
		"apply": func(player): player.speed *= 1.15
		
	},

	{
		"name": "Óleo Lubrificante",
		"description": "-25% cooldown do dash",
		"icon": preload("res://Icons/oilupgrade.png"),
		"apply": func(player): player.dash_cooldown *= 0.75
	},
	
	{
		"name": "Luvas de Couro",
		"description": "+25% no dano corpo a corpo",
		"icon": preload("res://Icons/gloveupgrade.png"),
		"apply": func(player): player.sword.damage *= 1.25
	},
]

func get_random_upgrades():
	var pool = all_upgrades.duplicate()
	pool.shuffle()
	return pool.slice(0, 3)
