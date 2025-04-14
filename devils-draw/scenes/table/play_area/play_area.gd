@tool
## PLAY AREA
# All passive cards go onto the table here
extends Node3D

@export var separation : float = 10.0
@export var size : float = 0.5

func _process(delta):
	
	# arrange children cards 
	var children = get_children()
	for i in range(len(children)):
		children[i].position.x = (separation * i) - ((len(children) - 1) * separation)/2
		children[i].scale = Vector3(size, size, size)
