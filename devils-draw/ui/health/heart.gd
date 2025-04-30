@tool
extends Sprite2D
class_name Heart

enum State {
	FULL,
	EMPTY,
	COOL,
	DAMAGED,
	HALF
}

@export var heart_state: State:
	set(new_state):
		heart_state = new_state
		refresh()

@export_range(0.0, 1.0) var amount : float = 1.0

func refresh():
	if heart_state == State.FULL:
		region_rect = Rect2(0, 0, 168, 147)
		material.set("shader_parameter/height", -1.0)
	elif heart_state == State.EMPTY:
		region_rect = Rect2(0, 536, 168, 155)
		material.set("shader_parameter/height", -1.0)
	elif heart_state == State.COOL:
		region_rect = Rect2(0, 1017, 168, 219)
		material.set("shader_parameter/height", -1.0)
	elif heart_state == State.HALF:
		material.set("shader_parameter/height", 0.06)
		region_rect = Rect2(0, 0, 168, 147)

func _process(delta):
	heart_state = State.FULL
	refresh()
	material.set("shader_parameter/height", remap(amount, 0.0, 1.0, 0.2, -0.1))
	
	if Engine.is_editor_hint():
		return
	
	if GameManager.has_effect(0, StatusEffect.Effects.BURNING):
		material.set("shader_parameter/burning", lerp(material.get_shader_parameter("burning"), 1.5, 0.1))
	else:
		material.set("shader_parameter/burning", lerp(material.get_shader_parameter("burning"), 0.0, 0.1))
