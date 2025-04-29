@tool
extends Node3D

@export var options : Array[SpiritOption] = []

const button = preload("res://scenes/main_room/spirit_bottle/spirit_menu_options/spirit_menu_option.tscn")

@export var pop : bool = false:
	set(new_val):
		populate()
@export var separation : float = 2.0

func _ready():
	populate()

func populate():
	for i in get_children():
		i.queue_free()
	
	for i in range(len(options)):
		var spirit_option : SpiritOption = options[i]
		var new_button = button.instantiate()
		add_child(new_button)
		
		new_button.position.y = -i*separation
		new_button.spirit_option = spirit_option

func _process(delta):
	if Engine.is_editor_hint():
		return
	
	look_at(get_viewport().get_camera_3d().global_position)
	global_rotation.y += PI
