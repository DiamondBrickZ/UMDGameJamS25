extends Node3D

@onready var shopkeeper_dialogue = $SubViewport/PanelContainer/MarginContainer/ShopkeeperDialogue
@onready var dialogue_timer = $DialogueTimer
@onready var sprite_3d = $Dialogue

@export var player_buys : Array[String] = [
	"Pleasure doing business with you.",
	"Good luck. You'll need it.",
	"Heh, that's a good choice!",
	"You'll be better off with this one."
]

@export var welcome_back : Array[String] = [
	"Heh, welcome back to the bar.",
	"Takin' it well in there?",
	"Back already?",
	"I got a good feeling about this one."
]

@export var player_revived : Array[String] = [
	"Welcome back to the land of the living. Kind of.",
	"Ouch, that seemed like it hurt."
]

@export var writing_duration : float = 1.5

func _ready():
	sprite_3d.visible = false
	GameManager.shop_dialogue.connect(write_dialogue)

func write_dialogue(text : String):
	var text_to_write : String = ""
	if text == "player_buys":
		text_to_write = player_buys.pick_random()
	elif text == "welcome_back":
		text_to_write = welcome_back.pick_random()
	elif text == "player_revived":
		text_to_write = player_revived.pick_random()
	elif text == "not_enough_gold":
		text_to_write = "I'm afraid you don't have enough gold in your pocket."
	
	shopkeeper_dialogue.text = text_to_write
	sprite_3d.visible = true
	
	# animate writing
	shopkeeper_dialogue.visible_ratio = 0.0
	var tween = get_tree().create_tween()
	tween.tween_property(shopkeeper_dialogue, "visible_ratio", 1.0, writing_duration)
	
	dialogue_timer.start()

func _on_dialogue_timer_timeout():
	sprite_3d.visible = false
