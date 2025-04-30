extends CardAction
class_name CardActionChangeModifier

@export var modifier_type := GameManager.ModifierTypes.HEALTH
@export var amount_added : float = 0.0

func do_action(my_character: int):
	GameManager.game_info[my_character]["modifiers"][modifier_type] += amount_added
