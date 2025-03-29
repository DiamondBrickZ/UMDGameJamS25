## DRAW PILE
# Clicking on this sends a request to the game loop to draw a card
extends Area3D

@export var player_marker : Marker3D
@export var devil_marker : Marker3D

var card_viewer = preload("res://card_viewers/3d_card_viewer.tscn")

func _ready():
	GameManager.card_drawn.connect(_on_card_drawn)

func _on_input_event(camera, event, event_position, normal, shape_idx):
	if Input.is_action_just_pressed("action"):
		GameManager.draw_card()

func _on_card_drawn(card: Card, character : int = 0):
	# create 3d card
	var viewer = card_viewer.instantiate()
	viewer.card = card
	add_child(viewer)
	
	var tween = get_tree().create_tween().set_parallel()
	if character == 0:
		# animate it going to player's hand
		tween.tween_property(viewer, "global_position", player_marker.global_position, 0.5)
		tween.tween_property(viewer, "rotation", Vector3(-3*PI/4, 0, 0), 0.5)
	else:
		# animate it going to devil's hand
		tween.tween_property(viewer, "global_position", devil_marker.global_position, 0.5)
		tween.tween_property(viewer, "rotation", Vector3(+3*PI/4, 0, 0), 0.5)
	await get_tree().create_timer(2).timeout
	viewer.queue_free()
