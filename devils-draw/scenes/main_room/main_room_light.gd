@tool
extends SpotLight3D

var increment = 0

func _process(delta):
	# swing
	increment += 0.03
	rotation.x = -PI/2 + 0.02 * sin(increment)
