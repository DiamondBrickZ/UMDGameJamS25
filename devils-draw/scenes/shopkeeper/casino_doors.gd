@tool
extends Node3D

@export var is_open: bool = false:
	set(new_val):
		is_open = new_val
		
		if get_tree():
			if is_open:
				open()
			else:
				close()
@export var left_door_marker: Marker3D
@export var right_door_marker: Marker3D

func open():
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property(left_door_marker, "rotation", Vector3(0, -PI/2, 0), 0.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(right_door_marker, "rotation", Vector3(0, PI/2, 0), 0.5).set_trans(Tween.TRANS_SINE)

func close():
	await get_tree().create_timer(1).timeout
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property(left_door_marker, "rotation", Vector3(0, 0, 0), 0.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(right_door_marker, "rotation", Vector3(0, 0, 0), 0.5).set_trans(Tween.TRANS_SINE)
