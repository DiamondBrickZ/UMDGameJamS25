extends Control

@export var anim_player : AnimationPlayer

func slide_in():
	anim_player.play("slide_in")

func slide_out():
	anim_player.play("slide_in", -1, -1.0, true)
