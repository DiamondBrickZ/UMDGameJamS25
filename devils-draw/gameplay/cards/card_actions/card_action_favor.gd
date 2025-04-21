extends CardAction
class_name CardActionFavor

func do_action(my_character : int):
	# get target character
	var other_character : int = 1
	if my_character == 1:	other_character = 0
	
	# get random card from their hand
	var their_hand : Array = GameManager.game_info[other_character]["hand"]
	var stolen_card : Card = their_hand.pick_random()
	
	# add it to my hand
	GameManager.add_card(my_character, stolen_card)
