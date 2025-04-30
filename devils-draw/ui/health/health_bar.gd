@tool
## HEALTH BAR
# Displays amount of health via hearts
extends Control

@export var separation: float = 40
@export var heart_size : float = 1.0

@export var speed : float = 1.0

var increment : float = 0.0
@onready var hearts = $Hearts

const heart = preload("res://ui/health/heart.tscn")

@export var create_hearts_button: bool = false:
	set(new_val):
		create_hearts()

@export var temp_health : float = 4.5

var hearts_array : Array[Sprite2D] = []
var health :float
var total_hearts: int

func _ready():
	GameManager.dealt_damage.connect(_on_dealt_damage)
	
	await get_tree().create_timer(0.2).timeout
	create_hearts()

func _on_dealt_damage(character: int, amount: float):
	pass

func create_hearts():
	total_hearts = GameManager.game_info[0]["max_health"]

	hearts_array = []
	for child in hearts.get_children():
		child.queue_free()
	
	for i in range(total_hearts):
		var new_heart = heart.instantiate()
		hearts.add_child(new_heart)
		hearts_array.append(new_heart)

func _process(delta):
	if total_hearts != int(GameManager.game_info[0]["max_health"]):
		create_hearts()
	
	health = lerpf(health, GameManager.game_info[0]["health"], 0.01)
	
	if Engine.is_editor_hint():
		health = temp_health
	
	for i in range(len(hearts_array)):
		var heart = hearts_array[i]
		heart.position.y = size.y/2 + sin(increment * delta * speed + i*10.0)
		heart.position.x = size.x/8 + i*separation
		heart.scale = Vector2(heart_size, heart_size)
		heart.amount = health - i
	
	increment += 1
