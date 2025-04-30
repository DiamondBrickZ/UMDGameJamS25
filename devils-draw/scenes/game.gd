## GAME SCRIPT
# Merges scenes between main room and shopkeeper, instancing to optimize
extends Node3D
class_name Game

var main_room = preload("res://scenes/main_room/main_room.tscn")
var shopkeeper_bar = preload("res://scenes/shopkeeper/shopkeeper_bar.tscn")
var main_menu = preload("res://scenes/main_menu/main_menu.tscn")

var main_room_instance : Node3D
var shopkeeper_bar_instance : Node3D
var main_menu_instance : Node3D
var transitioning = false
var cam_speed : float = 1.0
var increment : float = 0.0
var can_navigate : bool = true

# REFERENCES
@export var ui: CanvasLayer
@export var effects: CanvasLayer
@export var cam: Camera3D
@export var casino_doors : Node3D

# ENUMS
enum Locations {
	TABLE,
	SHOP,
	DEVIL,
	SPIRITS,
	MAIN_MENU
}

# LOCATIONS
@export var location_cams : Array[Camera3D] = []
@export var current_location := Locations.MAIN_MENU

# SIGNALS
signal new_instancing(new_location: Locations)

func _ready():
	instance_scene(current_location)
	GameManager.player_died.connect(_on_player_died)

func instance_scene(new_location: Locations):
	
	if new_location == Locations.SHOP:
		shopkeeper_bar_instance = shopkeeper_bar.instantiate()
		casino_doors.close()
		transitioning = true
		GameManager.current_game_state = GameManager.GameState.SHOP
		add_child(shopkeeper_bar_instance)
		
		# slide in shop menu
		if current_location == Locations.MAIN_MENU:
			await get_tree().create_timer(2.5).timeout
		else:
			await get_tree().create_timer(0.5).timeout
		ui.shop_menu.slide_in()
		
		GameManager.shop_dialogue.emit("welcome_back")
		
		# remove the main room instance
		await get_tree().create_timer(2).timeout
		if main_room_instance: main_room_instance.queue_free()
		if main_menu_instance: main_menu_instance.queue_free()

		await get_tree().create_timer(3).timeout
		transitioning = false
	elif new_location == Locations.TABLE:
		main_room_instance = main_room.instantiate()
		casino_doors.open()
		transitioning = true
		GameManager.current_game_state = GameManager.GameState.PLAYING
		add_child(main_room_instance)
		
		# slide out shop menu
		ui.shop_menu.slide_out()
		
		# remove the main room instance
		await get_tree().create_timer(2).timeout
		if shopkeeper_bar_instance: shopkeeper_bar_instance.queue_free()
		
		await get_tree().create_timer(3).timeout
		transitioning = false
	elif new_location == Locations.MAIN_MENU:
		main_menu_instance = main_menu.instantiate()
		transitioning = true
		add_child(main_menu_instance)
		
		#await get_tree().create_timer(2).timeout
		transitioning = false

func change_location(new_location: Locations):
	if not transitioning:	# dont allow movement while moving
		
		if new_location == Locations.MAIN_MENU:
			ui.hide()
			var effect = AudioServer.get_bus_effect(1, 0)
			var tween=get_tree().create_tween()
			tween.tween_property(effect, "cutoff_hz", 16000.0, 1.0)
		
		if current_location == Locations.MAIN_MENU:
			effects.show()
			ui.effects.anim_player.play("player_death")
			await get_tree().create_timer(2).timeout
			ui.show()

		if new_location == Locations.SHOP:
			instance_scene(Locations.SHOP)
			var effect = AudioServer.get_bus_effect(1, 0)
			var tween=get_tree().create_tween()
			tween.tween_property(effect, "cutoff_hz", 4500.0, 1.0)
		if current_location == Locations.SHOP and new_location == Locations.TABLE:
			instance_scene(Locations.TABLE)
			var effect = AudioServer.get_bus_effect(1, 0)
			var tween=get_tree().create_tween()
			tween.tween_property(effect, "cutoff_hz", 16000.0, 1.0)
		
		current_location = new_location
		GameManager.location_changed.emit(new_location)

func _on_player_died():
	can_navigate = false
	await get_tree().create_timer(4).timeout
	can_navigate = true

func _physics_process(delta):
	increment += 1 * delta
	var lerp_amount = 0.05 * cam_speed
	if transitioning:
		lerp_amount = 0.03 * cam_speed
	cam.position = lerp(cam.position, location_cams[current_location].position, lerp_amount)
	cam.rotation = lerp(cam.rotation, location_cams[current_location].rotation + Vector3(0.02 * sin(increment), 0.02 * sin(increment), 0.005 * sin(increment)), lerp_amount)
	cam.fov = lerp(cam.fov, location_cams[current_location].fov, lerp_amount)

func _on_pan_right_gui_input(_event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and current_location == Locations.TABLE and can_navigate:
		# pan to store
		change_location(Locations.SHOP)

func _on_pan_left_gui_input(_event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and current_location == Locations.SHOP and can_navigate:
		# pan to table
		change_location(Locations.TABLE)

func _on_pan_up_gui_input(_event):
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and current_location == Locations.TABLE:
		## pan to table
		#change_location(Locations.DEVIL)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and current_location == Locations.SHOP and can_navigate:
		change_location(Locations.TABLE)

func _on_pan_down_gui_input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_navigate:
		if current_location == Locations.DEVIL:
			change_location(Locations.TABLE)
		elif current_location == Locations.SPIRITS:
			change_location(Locations.TABLE)
		elif current_location == Locations.TABLE:
			change_location(Locations.SHOP)

func _on_spirit_bottle_input_event(camera, event, event_position, normal, shape_idx):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and current_location == Locations.TABLE and can_navigate:
		change_location(Locations.SPIRITS)

func _input(event):
	if event.is_action_pressed("move_back") and can_navigate:
		if current_location == Locations.TABLE:
			change_location(Locations.SHOP)
		elif current_location == Locations.SPIRITS:
			change_location(Locations.TABLE)
	elif event.is_action_pressed("move_forward") and can_navigate:
		if current_location == Locations.SHOP:
			change_location(Locations.TABLE)
		elif current_location == Locations.TABLE:
			change_location(Locations.SPIRITS)
