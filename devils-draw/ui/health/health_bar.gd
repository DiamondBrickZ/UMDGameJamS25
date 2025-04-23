@tool
## HEALTH BAR
# Displays amount of health via hearts
extends Control

@export var hearts: Control
@export var progress_bar: ProgressBar
@export var separation: float = 40
@export var heart_size : float = 1.0
@export var total_hearts: int = 5
@export var speed : float = 1.0

var increment : float = 0.0

var heart = preload("res://ui/health/heart.tscn")

@export var create_hearts_button: bool = false:
	set(new_val):
		create_hearts()

@export var temp_health : float = 4.5

#func _process(delta):
	#if Engine.is_editor_hint():
		#refresh()

var hearts_array : Array[Sprite2D] = []

func _ready():
	GameManager.dealt_damage.connect(_on_dealt_damage)
	
	create_hearts()

func _on_dealt_damage(character: int, amount: float):
	pass

func create_hearts():
	hearts_array = []
	for child in hearts.get_children():
		child.queue_free()
	
	for i in range(5):
		var new_heart = heart.instantiate()
		hearts.add_child(new_heart)
		hearts_array.append(new_heart)

func _process(delta):
	progress_bar.max_value = GameManager.game_info[0]["max_health"]
	progress_bar.value = GameManager.game_info[0]["health"]
	
	var health :float = GameManager.game_info[0]["health"]
	
	if Engine.is_editor_hint():
		health = temp_health
	
	for i in range(len(hearts_array)):
		var heart = hearts_array[i]
		heart.position.y = sin(increment * delta * speed + i*10.0)
		heart.position.x = i*separation
		heart.scale = Vector2(heart_size, heart_size)
		heart.amount = min(health - i, 1.0)
	
	increment += 1
