extends Area2D

@export var tool_tip_text : String = ""

func _ready():
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	GameManager.tooltip_component = self

func _on_mouse_exited():
	GameManager.tooltip_component = null

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseMotion:
		GameManager.tooltip_component = self
