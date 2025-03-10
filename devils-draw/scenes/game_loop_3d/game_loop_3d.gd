extends Node3D

var card_viewer_3d = preload("res://card_viewers/3d_card_viewer.tscn")
var test_card = preload("res://resources/cards/test_card/test_card.tres")

@export var ui: CanvasLayer
@export var cam: Camera3D

enum Locations {
	TABLE,
	SHOP
}

@export var location_cams : Array[Camera3D] = []

@export var current_location := Locations.TABLE

func draw_cards():
	# display 3 cards on table
	for i in range(3):
		var new_card = card_viewer_3d.instantiate()
		new_card.card = test_card
		$Cards.add_child(new_card)

func take_card(card_viewer: Area3D):
	
	# flip over the card first
	var tween = get_tree().create_tween()
	tween.tween_property(card_viewer.display, "rotation", Vector3(0, 0, PI), 0.4)
	await get_tree().create_timer(0.8).timeout
	
	# remove the card from the 3d scene, and put it into the player's hand
	var card = card_viewer.card
	card_viewer.queue_free()
	ui.hand_display.add_card(card)


func _physics_process(delta):
	cam.position = lerp(cam.position, location_cams[current_location].position, 0.05)
	cam.rotation = lerp(cam.rotation, location_cams[current_location].rotation, 0.05)


func _on_pan_right_gui_input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and current_location == Locations.TABLE:
		# pan to store
		current_location = Locations.SHOP

func _on_pan_left_gui_input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and current_location == Locations.SHOP:
		# pan to table
		current_location = Locations.TABLE
