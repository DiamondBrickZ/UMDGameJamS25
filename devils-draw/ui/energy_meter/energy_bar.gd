extends ProgressBar

@export var anim_player : AnimationPlayer

#func _ready():
	#GameManager.failed_move.connect(_on_failed_move)
	#GameManager.status_effect_change.connect(_on_status_effect_change)
#
#func _on_failed_move():
	#anim_player.play("not_enough_energy")

#func _on_status_effect_change(character: int, effect: StatusEffect, applied: bool):
	#if character == 0: # only show for player
		#if effect.effect_type == StatusEffect.Effects.DRUNKEN_HIGH:
			#if applied:
				#var tween = get_tree().create_tween()
			#else:
				#anim_player.play("drunken_high_end")

func _process(delta):
	
	# show energy level
	max_value = GameManager.game_info[0]["max_energy"]
	value = lerp(value, GameManager.game_info[0]["energy"], 0.1)
	
	var border_color : Color
	
	if GameManager.has_effect(0, StatusEffect.Effects.DRUNKEN_HIGH):
		border_color = Color.NAVY_BLUE
	else:
		border_color = Color.WHITE_SMOKE
	
	if material:
		material.border_color = lerp(material.border_color, border_color, 0.1)
