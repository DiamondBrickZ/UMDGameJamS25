@tool
extends Control

@onready var devil_health = $Sprite2D/DevilHealth
@onready var player_energy = $Sprite2D/PlayerEnergy

@export_range(0,1) var progress : float = 0:
	set(new_val):
		progress=new_val

func _process(delta):
	devil_health.value = GameManager.game_info[1]["health"]
	devil_health.max_value = GameManager.game_info[1]["max_health"]
