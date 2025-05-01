extends CardAction
class_name CardActionRemoveEffect

@export var effect_type := StatusEffect.Tag.NEGATIVE
@export var max_num : int = 1

func do_action(my_character: int):
	# remove a type of effect
	
	var effects_removed = 0
	for effect in GameManager.game_info[my_character]["status_effects"]:
		if effect.effect_tag == StatusEffect.Tag.NEGATIVE and effects_removed < max_num:
			GameManager.remove_status_effect(my_character, effect)
			effects_removed += 1
	
	print("Removed negative effects!")
