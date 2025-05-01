extends Node3D
@onready var canvas_layer = $CanvasLayer

func _ready():
	$CanvasLayer/AnimationPlayer.play("start", -1, -0.4, true)

func _on_button_pressed():
	if GameManager.do_tutorial:
		GameManager.start_intro()
	else:
		GameManager.start_game()
	$CanvasLayer/AnimationPlayer.play("start")
	await get_tree().create_timer(2).timeout
	canvas_layer.hide()
