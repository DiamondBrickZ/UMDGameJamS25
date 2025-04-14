extends Panel

@export var energy_bar: ProgressBar
@export var anim_player : AnimationPlayer

func _ready():
	GameManager.failed_move.connect(_on_failed_move)
	GameManager.status_effect_change.connect(_on_status_effect_change)
	
	energy_bar.max_value = GameManager.game_info[0]["max_energy"]

func _on_failed_move():
	anim_player.play("not_enough_energy")

func _on_status_effect_change(character: int, effect: StatusEffect, applied: bool):
	if character == 0: # only show for player
		if effect.effect_type == StatusEffect.Effects.DRUNKEN_HIGH:
			if applied:
				anim_player.play("drunken_high_start")
			else:
				anim_player.play("drunken_high_end")

func _process(delta):
	energy_bar.value = lerp(energy_bar.value, GameManager.game_info[0]["energy"], 0.1)
