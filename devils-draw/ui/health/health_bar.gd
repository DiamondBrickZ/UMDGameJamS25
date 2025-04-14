@tool
## HEALTH BAR
# Displays amount of health via hearts
extends Control

@export var hearts: Control
@export var progress_bar: ProgressBar
@export var separation: float = 40
@export var total_hearts: int = 5

@export var full_heart : PackedScene
@export var empty_heart: PackedScene
@export var cool_heart : PackedScene

#func _process(delta):
	#if Engine.is_editor_hint():
		#refresh()

func _ready():
	GameManager.dealt_damage.connect(refresh)
	
	#refresh()

func refresh():
	var health :float = GameManager.game_info[0]["health"]
	if Engine.is_editor_hint():
		health = 5
	var num_hearts = roundi(health)
	
	# remove existing hearts
	for i in hearts.get_children():
		i.queue_free()
	
	# add new ones
	for i in range(num_hearts):
		var new_heart = full_heart.instantiate()
		hearts.add_child(new_heart)
		new_heart.position.x = i*separation
	
	# add empty hearts
	for i in range(total_hearts - num_hearts):
		var new_heart = empty_heart.instantiate()
		hearts.add_child(new_heart)
		new_heart.position.x = len(num_hearts)*separation + i*separation

func _process(delta):
	progress_bar.max_value = GameManager.game_info[0]["max_health"]
	progress_bar.value = GameManager.game_info[0]["health"]
