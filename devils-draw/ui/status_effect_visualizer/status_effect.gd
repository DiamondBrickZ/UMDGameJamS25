@tool
extends Sprite2D

@onready var tool_tip_component_2d = $ToolTipComponent2D

@export var current_effect : StatusEffect:
	set(new_val):
		current_effect = new_val
		var effect_type = current_effect.effect_type
		
		if effect_type == StatusEffect.Effects.PARALYZED:
			frame_coords = Vector2(0,0)
		elif effect_type == StatusEffect.Effects.BURNING:
			frame_coords = Vector2(1, 0)
		elif effect_type == StatusEffect.Effects.TIPSY:
			frame_coords = Vector2(2, 0)
		elif effect_type == StatusEffect.Effects.POISONED:
			frame_coords = Vector2(3, 0)
		elif effect_type == StatusEffect.Effects.DRUNKEN_HIGH:
			frame_coords = Vector2(0, 1)
		elif effect_type == StatusEffect.Effects.BLEEDING:
			frame_coords = Vector2(1, 1)
		elif effect_type == StatusEffect.Effects.HASTE:
			frame_coords = Vector2(2, 1)
	
func _process(delta):
	if Engine.is_editor_hint():
		return
	
	tool_tip_component_2d.tool_tip_text = "[b]" + current_effect.status_name + "[/b] (" + str(int(current_effect.time_left)) + ")\n" + current_effect.status_desc
