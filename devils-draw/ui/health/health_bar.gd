@tool
## HEALTH BAR
# Displays amount of health via hearts
extends Node2D

@export var separation: float = 40
@export var heart_size : float = 1.0

@export var speed : float = 1.0

var increment : float = 0.0

const heart = preload("res://ui/health/heart.tscn")

@export var create_hearts_button: bool = false:
	set(new_val):
		create_hearts()

@export var temp_health : float = 4.5

var hearts_array : Array[Sprite2D] = []
var health :float

func _ready():
	GameManager.dealt_damage.connect(_on_dealt_damage)
	
	create_hearts()

func _on_dealt_damage(character: int, amount: float):
	pass

func create_hearts():
	hearts_array = []
	for child in get_children():
		child.queue_free()
	
	for i in range(5):
		var new_heart = heart.instantiate()
		add_child(new_heart)
		hearts_array.append(new_heart)

func _process(delta):
	var total_hearts: int = GameManager.game_info[0]["max_health"]
	
	health = lerpf(health, GameManager.game_info[0]["health"], 0.01)
	
	if Engine.is_editor_hint():
		health = temp_health
	
	for i in range(len(hearts_array)):
		var heart = hearts_array[i]
		heart.position.y = sin(increment * delta * speed + i*10.0)
		heart.position.x = i*separation
		heart.scale = Vector2(heart_size, heart_size)
		heart.amount = health - i
	
	increment += 1
