extends Control

@onready var label = $Label

func _process(delta):
	label.text = str(int(GameManager.game_info[0]["gold"]))
