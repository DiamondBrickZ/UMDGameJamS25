extends Button

var hovering : bool = false

func _on_mouse_entered():
	hovering = true

func _on_mouse_exited():
	hovering = false

func _on_gui_input(event):
	pass

func _process(delta):
	if hovering:
		modulate = modulate.lerp(Color("e62d15"), 0.1)
	else:
		modulate = modulate.lerp(Color.WHITE, 0.1)
