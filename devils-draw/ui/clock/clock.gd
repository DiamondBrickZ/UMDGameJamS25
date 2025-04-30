@tool
extends Control

@onready var body = $Body
@onready var hand = $Hand

@export var temp : float = 1.0

func _process(delta):
	var time_left : float
	
	if Engine.is_editor_hint():
		time_left = temp
	else:
		time_left = GameManager.time_left
	
	var target = remap(time_left, 0.0, 90.0, 0.0, -2*PI)
	hand.rotation = lerp(hand.rotation, target, 0.1)
