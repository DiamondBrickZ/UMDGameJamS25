@tool
## SPIRIT BOTTLE
# Visually represents the number of souls/spirits the player has

extends Area3D

@onready var menu_options = $SpiritsMenu

func _ready():
	GameManager.location_changed.connect(_on_location_changed)
	GameManager.soul_gained.connect(_on_soul_gained)
	menu_options.hide()

func _on_location_changed(new_location):
	if new_location == get_tree().current_scene.Locations.SPIRITS:
		menu_options.visible = true
	else:
		menu_options.visible = false

func _on_soul_gained():
	var tween = get_tree().create_tween()
	tween.tween_property($Spirits, "material:shader_parameter/amount", GameManager.game_info[0]["souls"] * 0.5, 1).set_trans(Tween.TRANS_SINE)
