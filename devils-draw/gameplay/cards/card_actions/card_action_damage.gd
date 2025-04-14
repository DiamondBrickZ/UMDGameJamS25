extends CardAction
class_name CardActionDamage

enum Subject {
	TO_SELF,
	TO_ENEMY
}

@export var subject := Subject.TO_ENEMY
@export var damage_amount : float = 1.0

func do_action(my_character: int):
	if my_character == 0:
		print("Dealing " + str(damage_amount) + " damage to devil")
		GameManager.deal_damage(1, damage_amount)
	else:
		print("Dealing " + str(damage_amount) + " damage to player")
		GameManager.deal_damage(0, damage_amount)
