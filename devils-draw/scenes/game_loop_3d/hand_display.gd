extends Panel

var card_viewer_2d = preload("res://card_viewers/ui_card_viewer.tscn")

@export var separation : float = 10

func add_card(card: Card):
	var card_viewer = card_viewer_2d.instantiate()
	card_viewer.card = card
	add_child(card_viewer)

func get_card_viewer_index(card_viewer):
	for i in range(len(get_children())):
		if get_children()[i] == card_viewer:
			return i

func _process(delta):
	
	# arrange cards
	var children = get_children()
	var num_children = len(children)
	for i in range(num_children):
		
		var center = size/2
		var target_pos = (i * separation) - ((num_children-1)*separation)/2
		children[i].position = lerp(children[i].position, Vector2(target_pos, 0) + center, 0.1)
		
