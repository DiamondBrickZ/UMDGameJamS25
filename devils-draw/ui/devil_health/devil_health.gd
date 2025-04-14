extends Control

@export var progress_bar : ProgressBar

func _ready():
	progress_bar.max_value = GameManager.game_info[1]["max_health"]

func _process(delta):
	progress_bar.value = GameManager.game_info[1]["health"]
