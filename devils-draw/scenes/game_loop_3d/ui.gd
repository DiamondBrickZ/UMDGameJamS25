extends CanvasLayer

@export var hand_display: Panel

func _on_draw_cards_pressed():
	# send a message to draw cards
	get_tree().current_scene.draw_cards()
