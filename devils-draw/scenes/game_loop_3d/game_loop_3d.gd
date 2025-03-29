## GAME LOOP 3D
# Handles game events after checking with GameManager
extends Node3D

# PRELOADS
var card_viewer_3d = preload("res://card_viewers/3d_card_viewer.tscn")
var test_card = preload("res://resources/cards/test_card/test_card.tres")

# REFERENCES
@export var ui: CanvasLayer
@export var cam: Camera3D

# ENUMS
enum Locations {
	TABLE,
	SHOP,
	DEVIL,
	SPIRITS
}

# LOCATIONS
@export var location_cams : Array[Camera3D] = []
@export var current_location := Locations.TABLE

# SIGNALS
signal location_changed(new_location)

func draw_card(card : Card, character: int):
	# draws one card for the player or devil
	print("Drawing card")
	
	if character == 0:
		ui.hand_display.add_card(card)
#
#func draw_cards():
	## display 3 cards on table
	#for i in range(3):
		#var new_card = card_viewer_3d.instantiate()
		#new_card.card = test_card
		#$Cards.add_child(new_card)

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
	cam.fov = lerp(cam.fov, location_cams[current_location].fov, 0.05)

func _on_pan_right_gui_input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and current_location == Locations.TABLE:
		# pan to store
		current_location = Locations.SHOP
		location_changed.emit(current_location)

func _on_pan_left_gui_input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and current_location == Locations.SHOP:
		# pan to table
		current_location = Locations.TABLE
		location_changed.emit(current_location)

func _on_pan_up_gui_input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and current_location == Locations.TABLE:
		# pan to table
		current_location = Locations.DEVIL
		location_changed.emit(current_location)

func _on_pan_down_gui_input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if current_location == Locations.DEVIL:
			# pan to table
			current_location = Locations.TABLE
			location_changed.emit(current_location)
		elif current_location == Locations.SPIRITS:
			current_location = Locations.TABLE 
			location_changed.emit(current_location)

func _on_spirit_bottle_input_event(camera, event, event_position, normal, shape_idx):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and current_location == Locations.TABLE:
		# pan to table
		current_location = Locations.SPIRITS
		location_changed.emit(current_location)
