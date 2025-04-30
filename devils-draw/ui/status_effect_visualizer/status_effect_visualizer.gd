extends Control

const STATUS_EFFECT = preload("res://ui/status_effect_visualizer/status_effect.tscn")
@export var separation : float = 40.0
@export var character :int = 0
@export var direction : int = 1

func _ready():
	GameManager.status_effect_change.connect(_on_status_effect_change)

func _on_status_effect_change(char: int, effect: StatusEffect, applied: bool):
	
	# only do for selected character
	if character != char:
		return
	
	# clear existing effects
	for i in get_children():
		i.queue_free()
	
	# add new ones
	for i in range(len(GameManager.game_info[character]["status_effects"])):
		var new_effect : StatusEffect = GameManager.game_info[character]["status_effects"][i]
		var new_child = STATUS_EFFECT.instantiate()
		new_child.current_effect = new_effect.effect_type
		new_child.position.x = direction * i * separation
		add_child(new_child)
