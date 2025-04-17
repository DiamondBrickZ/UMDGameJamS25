extends Button

@onready var label = $Label

@export var menu_title : String = "title":
	set(new_title):
		menu_title = new_title
		if label:
			refresh()

func _ready():
	refresh()

func refresh():
	label.text = menu_title
