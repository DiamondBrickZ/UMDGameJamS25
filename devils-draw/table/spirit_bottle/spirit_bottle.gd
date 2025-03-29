extends Area3D

@export var label : Label3D

func _ready():
	get_tree().current_scene.location_changed.connect(_on_location_changed)

func _on_location_changed(new_location):
	if new_location == get_tree().current_scene.Locations.SPIRITS:
		label.visible = true
	else:
		label.visible = false
