extends Control

@onready var button = $Button
var hovering : bool = false

func _ready():
	GameManager.game_end.connect(_on_game_end)
	visible = false

func _on_button_pressed():
	get_tree().quit()

func _on_game_end(won: bool):
	if won:
		visible = true
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color(1,1,1,1), 4.0)


func _on_button_mouse_entered():
	hovering = true

func _on_button_mouse_exited():
	hovering = false

func _process(delta):
	if hovering:
		button.modulate = button.modulate.lerp(Color("76d1ca"), 0.1)
	else:
		button.modulate = button.modulate.lerp(Color.WHITE, 0.1)
