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

@onready var back_to_shop = $BackToShop

func _ready():
	visible = false

func _on_draw_cards_pressed():
	# send a message to draw cards
	get_tree().current_scene.draw_cards()
