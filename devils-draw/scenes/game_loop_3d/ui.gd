## UI
# Handles UI elements, at a meta-level
extends CanvasLayer

# REFERENCES
@export var hand_display: Panel
@export var gold_label : Label
@export var time_left : Label
@export var energy_bar : ProgressBar
@export var ui_animations : AnimationPlayer

func _on_draw_cards_pressed():
	# send a message to draw cards
	get_tree().current_scene.draw_cards()

func _process(delta):
	gold_label.text = "Gold: " + str(GameManager.player_gold)
	time_left.text = "Time Left: " + str(round(GameManager.time_left))
	energy_bar.value = lerp(energy_bar.value, GameManager.player_energy, 0.1)
	energy_bar.max_value = GameManager.player_energy_max
