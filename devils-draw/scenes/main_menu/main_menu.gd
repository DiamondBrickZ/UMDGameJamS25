extends Node3D
@onready var canvas_layer = $CanvasLayer

func _ready():
	$CanvasLayer/AnimationPlayer.play("start", -1, -0.4, true)

func _on_button_pressed():
	get_parent().change_location(Game.Locations.SHOP)
	$CanvasLayer/AnimationPlayer.play("start")
	await get_tree().create_timer(2).timeout
	canvas_layer.hide()
	GameManager.game_start.emit()
