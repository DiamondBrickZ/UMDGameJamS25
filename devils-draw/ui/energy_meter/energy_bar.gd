extends ProgressBar

@export var player : int = 0

func _process(delta):
	
	# show energy level
	max_value = GameManager.game_info[player]["max_energy"]
	value = lerp(value, GameManager.game_info[player]["energy"], 0.1)
	
	var border_color : Color
	
	# drunken high
	if GameManager.has_effect(player, StatusEffect.Effects.DRUNKEN_HIGH):
		border_color = Color.NAVY_BLUE
	else:
		border_color = Color.WHITE_SMOKE
	
	if material:
		material.border_color = lerp(material.border_color, border_color, 0.1)
