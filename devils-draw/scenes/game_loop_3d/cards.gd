@tool
extends Node3D

@export var separation : float = 100.0

func _physics_process(delta):
	
	# arrange all children
	var children = get_children()
	var num_children = len(children)
	for i in range(num_children):
		var target_pos = (i * separation) - ((num_children-1)*separation)/2
		children[i].position.x = lerpf(children[i].position.x, target_pos, 0.1)
