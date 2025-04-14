## GAME LOOP 3D
# Handles game events after checking with GameManager
extends Node3D

# PRELOADS
var card_viewer_3d = preload("res://gameplay/cards/card_viewers/3d_card_viewer.tscn")

func take_card(card_viewer: Area3D):
	
	# flip over the card first
	var tween = get_tree().create_tween()
	tween.tween_property(card_viewer.display, "rotation", Vector3(0, 0, PI), 0.4)
	await get_tree().create_timer(0.8).timeout
	
	# remove the card from the 3d scene, and put it into the player's hand
	var card = card_viewer.card
	card_viewer.queue_free()
	get_parent().ui.hand_display.add_card(card)

func _on_spirit_bottle_input_event(camera, event, event_position, normal, shape_idx):
	get_tree().current_scene._on_spirit_bottle_input_event(camera, event, event_position, normal, shape_idx)	# pass it forward
