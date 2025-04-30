extends CardAction
class_name CardActionGainGold

@export var gold_amount : float = 1.0

func do_action(my_character: int):
	gold_amount *= GameManager.passives["gold_multiplier"]
	gold_amount = floor(gold_amount)
	
	print("Character " + str(my_character) + " gaining " + str(gold_amount) + " gold!")
	GameManager.game_info[my_character]["gold"] += gold_amount
