extends CardAction
class_name CardActionFakeMembership

func do_action(my_character: int):
	
	if my_character == 0:
		# enable fake membership. effect is handled in game manager
		GameManager.fake_membership = true
