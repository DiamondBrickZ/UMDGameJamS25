extends Control

func _ready():
	GameManager.game_end.connect(_on_game_end)
	visible = false

func _on_button_pressed():
	get_tree().quit()

func _on_game_end(won: bool):
	if not won:
		visible = true
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color(1,1,1,1), 4.0)
