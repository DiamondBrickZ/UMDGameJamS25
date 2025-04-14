@tool
extends Area3D

var hovering: bool = false
var being_taken: bool = false
@export var back_cover: Sprite3D
@export var front_cover: Sprite3D
@export var display: Node3D
@export var card: Card:
	set(new_card):
		card = new_card
		
		if back_cover:
			back_cover.texture = card.back
			front_cover.texture = card.cover

func _ready():
	back_cover.texture = card.back
	front_cover.texture = card.cover

#func _on_mouse_entered():
	#hovering = true
#
#func _on_mouse_exited():
	#hovering = false
#
#func _physics_process(delta):
	#
	## hover animation
	#if hovering:
		#display.position.y = lerpf(display.position.y, 0.1, 0.1)
	#else:
		#display.position.y = lerpf(display.position.y, 0, 0.1)
#
#func _on_input_event(camera, event, event_position, normal, shape_idx):
	#
	## if clicked on card
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and hovering and not being_taken:
		#being_taken = true
		#hovering = false
		#get_tree().current_scene.take_card(self)
