@tool
extends Control

#@onready var devil_health = $Sprite2D/DevilHealth
#@onready var player_energy = $Sprite2D/PlayerEnergy

@onready var devil_bar_health = $DevilBarFrame/DevilBarHealth
@onready var devil_bar_energy = $DevilBarFrame/DevilBarEnergy

@export_range(0,1) var progress : float = 0:
	set(new_val):
		progress=new_val

func _process(delta):
	#devil_health.value = GameManager.game_info[1]["health"]
	#devil_health.max_value = GameManager.game_info[1]["max_health"]
	
	if Engine.is_editor_hint():
		return
	
	var parameter = devil_bar_health.material.get_shader_parameter("amount")
	var target_val = remap(GameManager.game_info[1]["health"], 0, GameManager.game_info[1]["max_health"], 0, 1.0)
	devil_bar_health.material.set_shader_parameter("amount", lerp(parameter, target_val, 0.1))
	
	parameter = devil_bar_energy.material.get_shader_parameter("amount")
	target_val = remap(GameManager.game_info[1]["energy"], 0, GameManager.game_info[1]["max_energy"], 0, 1.0)
	devil_bar_energy.material.set_shader_parameter("amount", lerp(parameter, target_val, 0.1))
