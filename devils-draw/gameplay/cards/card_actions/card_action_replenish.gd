extends CardAction
class_name CardActionReplenish

@export var energy_replenished: float = 1.0

func do_action(my_character: int):
	GameManager.game_info[my_character]["energy"] += energy_replenished
