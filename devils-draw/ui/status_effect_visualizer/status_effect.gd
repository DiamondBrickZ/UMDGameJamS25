@tool
extends Sprite2D

@export var current_effect := StatusEffect.Effects.BURNING:
	set(new_val):
		current_effect = new_val
		
		if current_effect == StatusEffect.Effects.PARALYZED:
			frame_coords = Vector2(0,0)
		elif current_effect == StatusEffect.Effects.BURNING:
			frame_coords = Vector2(1, 0)
		elif current_effect == StatusEffect.Effects.TIPSY:
			frame_coords = Vector2(2, 0)
		elif current_effect == StatusEffect.Effects.POISONED:
			frame_coords = Vector2(3, 0)
		elif current_effect == StatusEffect.Effects.DRUNKEN_HIGH:
			frame_coords = Vector2(0, 1)
		elif current_effect == StatusEffect.Effects.BLEEDING:
			frame_coords = Vector2(1, 1)
		elif current_effect == StatusEffect.Effects.HASTE:
			frame_coords = Vector2(2, 1)
