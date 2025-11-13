extends Node

var level: int = 1
var xp: float = 0
var xp_to_next: float = 5  # XP required for level 1 → 2
@onready var level_up_sound: AudioStreamPlayer2D = $LevelUpSound
@onready var label: Label = $"../CanvasLayer/Label"

func add_xp(amount: float) -> void:
	xp += amount
	_check_level_up()
	_update_ui()

func _check_level_up() -> void:
	while xp >= xp_to_next:
		xp -= xp_to_next
		level += 1
		xp_to_next = _xp_required_for(level)
		_on_level_up()

func _xp_required_for(lvl: int) -> float:
	var base_xp = xp_to_next
	var growth_rate = 1.25
	return base_xp * pow(growth_rate, lvl - 1)

func _on_level_up() -> void:
	level_up_sound.play()

func _update_ui() -> void:
	if label:
		label.text = "Lv %d — XP: %d / %d" % [level, xp, xp_to_next]
