extends CardAction
class_name CardActionApplyEffect

enum Subject {
	TO_SELF,
	TO_ENEMY
}

@export var subject := Subject.TO_SELF
@export var duration : float = 10.0
@export var effect : StatusEffect

func do_action(my_character: int):
	var character = my_character
	if subject == Subject.TO_ENEMY:
		if my_character == 0:	character = 1
		else:					character = 0
	
	print("Giving character " + str(character) + " " + str(duration) + " sec of " + effect.status_name)
	
	# create new effect resource, as the time info should not be shared amongst all
	var new_effect : StatusEffect = effect.duplicate()
	new_effect.time_left = duration
	GameManager.apply_status_effect(character, new_effect)
	return true
