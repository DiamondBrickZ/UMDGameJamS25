@tool
## PLAY AREA
# All passive cards go onto the table here
extends Node3D

@export var player_marker :Marker3D
@export var devil_marker : Marker3D
@export var separation : float = 10.0
@export var size : float = 0.5

var card_3d = preload("res://gameplay/cards/card_viewers/3d_card_viewer.tscn")

func _ready():
	GameManager.card_played.connect(_on_card_played)
	
	for card in GameManager.discard_pile:
		_on_card_played(card, 1)

func _on_card_played(card: Card, character : int):
	# instantiate 3d card
	var new_card = card_3d.instantiate()
	new_card.card = card
		
	if character == 0:
		add_child(new_card)
		new_card.global_position = player_marker.global_position
	else:
		# create a slight delay
		await get_tree().create_timer(0.4).timeout
		add_child(new_card)
		new_card.global_position = devil_marker.global_position

func _process(delta):
	
	# arrange children cards 
	var children = get_children()
	for i in range(len(children)):
		#children[i].position.x = (separation * i) - ((len(children) - 1) * separation)/2
		var target_position = global_position + Vector3(0, separation * i, 0)
		children[i].global_position = lerp(children[i].global_position, target_position, 0.1)
		children[i].global_rotation = lerp(children[i].global_rotation, Vector3(0, 0, PI), 0.1)
		children[i].scale = Vector3(size, size, size)
