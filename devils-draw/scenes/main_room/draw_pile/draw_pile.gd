## DRAW PILE
# Clicking on this sends a request to the game loop to draw a card
extends Area3D

@export var player_marker : Marker3D
@export var devil_marker : Marker3D
@export var timer : Timer

var card_viewer = preload("res://gameplay/cards/card_viewers/3d_card_viewer.tscn")
var can_draw = true

func _ready():
	GameManager.card_drawn.connect(_on_card_drawn)

func _on_input_event(_camera, _event, _event_position, _normal, _shape_idx):
	if Input.is_action_just_pressed("action") and can_draw:
		GameManager.draw_card()
		GameManager.devil_turn()
		can_draw = false
		timer.start()

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


func _on_timer_timeout():
	can_draw = true
