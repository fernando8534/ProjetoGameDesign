extends CanvasLayer

@onready var panel = $Panel
@onready var options = [$Panel/Option1, $Panel/Option2, $Panel/Option3]
@onready var upgrade_manager = $"../UpgradeManager"

var current_options = []
var player_ref = null

func show_upgrades(player):
	current_options = upgrade_manager.get_random_upgrades()
	player_ref = player
	for i in range(3):
		var option = options[i]
		var upgrade = current_options[i]
		
		option.get_node("Button").text = "%s\n%s" % [ upgrade["name"], upgrade["description"] ]
		option.get_node("TextureRect").texture = upgrade["icon"]
		
		# linka o botão com o função
		option.get_node("Button").pressed.connect(Callable(self, "_on_button_pressed").bind(i))
			
	panel.visible = true
	get_tree().paused = true

func _on_button_pressed(i):
	var chosen = current_options[i]
	chosen["apply"].call(player_ref)
	
	# restaura o hp do player ao máximo por ter subido de nível
	player_ref.restore_max_health()
	panel.visible = false
	get_tree().paused = false
