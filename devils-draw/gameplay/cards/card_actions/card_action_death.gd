extends CardAction
class_name CardActionDeath

func do_action(my_character: int):
	if my_character == 0:
		print("Player dies")
		GameManager.player_death()
