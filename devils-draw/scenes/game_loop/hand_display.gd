@tool
extends PanelContainer

@export var separation: float = 1.0:
	set(new_val):
		separation = new_val
		organize_cards()
@export var card_size: float = 1.0:
	set(new_val):
		card_size = new_val
		organize_cards()
		
func _ready():
	child_entered_tree.connect(_on_card_enters_hand)

func _on_card_enters_hand(node: Node):
	organize_cards()

func organize_cards():
	for i in len(get_children()):
		var card = get_child(i)
		card.size = card_size
		var center = global_position + size/2
		var offset = (i - (get_child_count()+1)/2) * card_size * separation
		card.global_position = center + Vector2(offset, 0)
