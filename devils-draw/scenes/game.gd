## GAME SCRIPT
# Merges scenes between main room and shopkeeper, instancing to optimize
extends Node3D

var main_room = preload("res://scenes/game_loop_3d/main_room.tscn")
var shopkeeper_bar = preload("res://scenes/shopkeeper/shopkeeper_bar.tscn")

var main_room_instance : Node3D
var shopkeeper_bar_instance : Node3D
var transitioning = false
var increment : float = 0.0

# REFERENCES
@export var ui: CanvasLayer
@export var cam: Camera3D
@export var casino_doors : Node3D

# ENUMS
enum Locations {
	TABLE,
	SHOP,
	DEVIL,
	SPIRITS
}

# LOCATIONS
@export var location_cams : Array[Camera3D] = []
@export var current_location := Locations.SHOP

# SIGNALS
signal location_changed(new_location)
signal new_instancing(new_location: Locations)

func _ready():
	instance_scene(current_location)

func instance_scene(new_location: Locations):
	
	if new_location == Locations.SHOP:
		shopkeeper_bar_instance = shopkeeper_bar.instantiate()
		casino_doors.close()
		transitioning = true
		add_child(shopkeeper_bar_instance)
		
		# slide in shop menu
		await get_tree().create_timer(0.5).timeout
		ui.shop_menu.slide_in()
		
		# remove the main room instance
		await get_tree().create_timer(2).timeout
		if main_room_instance: main_room_instance.queue_free()
		
		await get_tree().create_timer(3).timeout
		transitioning = false
		
	elif new_location == Locations.TABLE:
		main_room_instance = main_room.instantiate()
		casino_doors.open()
		transitioning = true
		add_child(main_room_instance)
		
		# slide out shop menu
		ui.shop_menu.slide_out()
		
		# remove the main room instance
		await get_tree().create_timer(2).timeout
		if shopkeeper_bar_instance: shopkeeper_bar_instance.queue_free()
		
		await get_tree().create_timer(5).timeout
		transitioning = false

func change_location(new_location: Locations):
	if not transitioning:	# dont allow movement while moving
		if current_location == Locations.TABLE and new_location == Locations.SHOP:
			instance_scene(Locations.SHOP)
		if current_location == Locations.SHOP and new_location == Locations.TABLE:
			instance_scene(Locations.TABLE)
		
		current_location = new_location
		location_changed.emit(new_location)

func _physics_process(delta):
	increment += 1 * delta
	var lerp_amount = 0.05
	if transitioning:
		lerp_amount = 0.03
	cam.position = lerp(cam.position, location_cams[current_location].position, lerp_amount)
	cam.rotation = lerp(cam.rotation, location_cams[current_location].rotation + Vector3(0.02 * sin(increment), 0.02 * sin(increment), 0.005 * sin(increment)), lerp_amount)
	cam.fov = lerp(cam.fov, location_cams[current_location].fov, 0.05)

func _on_pan_right_gui_input(_event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and current_location == Locations.TABLE:
		# pan to store
		change_location(Locations.SHOP)

func _on_pan_left_gui_input(_event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and current_location == Locations.SHOP:
		# pan to table
		change_location(Locations.TABLE)

func _on_pan_up_gui_input(_event):
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and current_location == Locations.TABLE:
		## pan to table
		#change_location(Locations.DEVIL)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and current_location == Locations.SHOP:
		change_location(Locations.TABLE)
		

func _on_pan_down_gui_input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if current_location == Locations.DEVIL:
			change_location(Locations.TABLE)
		elif current_location == Locations.SPIRITS:
			change_location(Locations.TABLE)
		elif current_location == Locations.TABLE:
			change_location(Locations.SHOP)

func _on_spirit_bottle_input_event(camera, event, event_position, normal, shape_idx):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and current_location == Locations.TABLE:
		change_location(Locations.SPIRITS)
