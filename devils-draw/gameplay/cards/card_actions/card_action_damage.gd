extends CardAction
class_name CardActionDamage

enum Subject {
	TO_SELF,
	TO_ENEMY
}

@export var subject := Subject.TO_ENEMY
@export var damage_amount : float = 1.0

func do_action(my_character: int):
	# define target
	var target : int = 0
	if subject == Subject.TO_SELF:
		target = my_character
	else:
		target = 0
		if my_character == 0:
			target = 1
	
	# add damage multiplier
	damage_amount *= GameManager.game_info[my_character]["modifiers"][GameManager.ModifierTypes.DAMAGE]
	
	if target == 0:
		print("Dealing " + str(damage_amount) + " damage to player")
	else:
		print("Dealing " + str(damage_amount) + " damage to devil")

	GameManager.deal_damage(target, damage_amount)
