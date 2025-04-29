@tool
extends Area3D

@onready var label = $Label3D
@onready var collision = $CollisionShape3D
var hovering: bool = false

@export var spirit_option : SpiritOption:
	set(new_val):
		spirit_option = new_val
		set_data()
@export var been_bought : bool = false:
	set(new_val):
		been_bought = new_val
		set_data()

func set_data():
	label.text = spirit_option.display
	label.text += " (" + str(spirit_option.soul_cost) + " souls)"
	
	if been_bought:
		label.modulate = Color.WEB_GREEN

func _on_input_event(camera, event, event_position, normal, shape_idx):
	if Input.is_action_just_pressed("action"):
		GameManager.sell_soul(spirit_option)

func _on_mouse_entered():
	hovering = true

func _on_mouse_exited():
	hovering = false

func _process(delta):
	if hovering and not been_bought:
		label.modulate = lerp(label.modulate, Color.LIGHT_BLUE, 0.1)
	elif hovering and not been_bought:
		label.modulate = lerp(label.modulate, Color.WHITE, 0.1)
	
	if been_bought:
		label.modulate = Color.WEB_GREEN
