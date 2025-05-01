extends Button

var game

var reset_point: Marker2D

func _ready():
	game = get_tree().current_scene

func _process(delta):
	if game.current_location == Game.Locations.TABLE:
		position = position.lerp(Vector2(1541,926), 0.1)
		text = "Go back to shop."
	elif game.current_location == Game.Locations.SPIRITS:
		position = position.lerp(Vector2(1541,926), 0.1)
		text = "Go back to table."
	else:
		position = position.lerp(Vector2(3000,926), 0.1)

func _on_pressed():
	if game.current_location == Game.Locations.TABLE:
		get_tree().current_scene.change_location(Game.Locations.SHOP)
	elif game.current_location == Game.Locations.SPIRITS:
		get_tree().current_scene.change_location(Game.Locations.TABLE)
