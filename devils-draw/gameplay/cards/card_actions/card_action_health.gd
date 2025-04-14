extends CardAction
class_name CardActionHealth

@export var health_gained : float = 1.0
@export var overflow : bool = false

func do_action(my_character: int):
	GameManager.game_info[my_character]["health"] += health_gained
	
	if not overflow:
		if GameManager.game_info[my_character]["health"] > GameManager.game_info[my_character]["max_health"]:
			GameManager.game_info[my_character]["health"] == GameManager.game_info[my_character]["max_health"]
