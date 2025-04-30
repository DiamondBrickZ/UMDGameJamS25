extends PanelContainer

@onready var rich_text_label = $MarginContainer/RichTextLabel

func _process(delta):
	if GameManager.tooltip_component:
		visible = true
		rich_text_label.text = GameManager.tooltip_component.tool_tip_text
		global_position = get_viewport().get_mouse_position() + Vector2(10.0,10.0)
		if size.y > 100: size.y = 300
		if global_position.x > get_viewport().size.x*2 - 300:
			global_position.x = get_viewport().size.x*2 - 300
		if global_position.y > get_viewport().size.y*2 - 200:
			global_position.y = get_viewport().size.y*2 - 200
	else:
		visible = false
