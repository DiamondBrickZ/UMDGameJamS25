## UI
# Handles UI elements, at a meta-level
extends CanvasLayer

# REFERENCES
@export var hand_display: Control
@export var gold_label : Label
@export var time_left : Label
@export var energy_bar : ProgressBar
@export var ui_animations : AnimationPlayer
@export var shop_menu : Control
@export var effects : Control

func _on_draw_cards_pressed():
	# send a message to draw cards
	get_tree().current_scene.draw_cards()

func _process(delta):
	gold_label.text = "Gold: " + str(GameManager.game_info[0]["gold"])
	time_left.text = "Time Left: " + str(round(GameManager.time_left))
