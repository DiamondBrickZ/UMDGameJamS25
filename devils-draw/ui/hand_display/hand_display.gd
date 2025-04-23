@tool
extends Control

@export var card_name_label : Label
@export var cards : Control

var card_viewer_2d = preload("res://gameplay/cards/card_viewers/ui_card_viewer.tscn")

@export var base_scale : float = 1.0
@export var separation : float = 10
@export var rotation_amount : float = 8.0
var selected_card : Area2D

func _ready():
	GameManager.player_died.connect(_on_player_died)
	GameManager.card_drawn.connect(_on_card_drawn)

func _on_card_drawn(card: Card, character: int):
	if character == 0:
		add_card(card)

func _on_player_died():
	for child in cards.get_children():
		child.queue_free()

func add_card(card: Card):
	var card_viewer : Area2D = card_viewer_2d.instantiate()
	card_viewer.card = card
	cards.add_child(card_viewer)

func get_card_viewer_index(card_viewer):
	for i in range(len(cards.get_children())):
		if cards.get_children()[i] == card_viewer:
			return i

func _process(delta):
	
	# arrange cards
	var children = cards.get_children()
	var num_children = len(children)
	for i in range(num_children):
		
		# spread the cards out
		var center = cards.size/2
		var target_pos = (i * separation) - ((num_children-1)*separation)/2
		children[i].target_position = Vector2(target_pos, 0) + center
		
		# rotate around center
		if len(children) == 1:
			children[i].target_rotation = 0
		else:
			children[i].target_rotation = remap(i, 0, len(children)-1, -PI/rotation_amount, +PI/rotation_amount)
		
		# lift selected card
		if children[i] == selected_card:
			children[i].target_position -= Vector2(0, 50)
			# expand too
			children[i].scale = lerp(children[i].scale, Vector2(base_scale*1.1,base_scale*1.1), 0.1)
		else:
			children[i].scale = lerp(children[i].scale, Vector2(base_scale,base_scale), 0.1)
	
	if selected_card:
		card_name_label.text = selected_card.card.title
	else:
		card_name_label.text = ""
