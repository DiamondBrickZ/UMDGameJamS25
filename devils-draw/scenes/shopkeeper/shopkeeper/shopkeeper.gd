@tool
extends Sprite3D
class_name Shopkeeper

enum Emotion {
	FRIENDLY,
	SCARED,
	HAPPY,
	SURPRISED,
	HUMBLED,
	SPOOKED,
	TIRED,
	MISCHEVIOUS
}

@export var emotion:= Emotion.FRIENDLY:
	set(new_val):
		emotion = new_val
		
		_set_emotion(emotion)


@export var shopkeeper_dialogue : RichTextLabel
@export var dialogue_timer : Timer
@export var sprite_3d : Sprite3D

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
		emotion = Emotion.HAPPY
	elif text == "welcome_back":
		text_to_write = welcome_back.pick_random()
		emotion = Emotion.FRIENDLY
	elif text == "player_revived":
		text_to_write = player_revived.pick_random()
		emotion = Emotion.SPOOKED
	elif text == "not_enough_gold":
		text_to_write = "I'm afraid you don't have enough gold in your pocket."
		emotion = Emotion.FRIENDLY
	
	shopkeeper_dialogue.text = text_to_write
	sprite_3d.visible = true
	
	# animate writing
	shopkeeper_dialogue.visible_ratio = 0.0
	var tween = get_tree().create_tween()
	tween.tween_property(shopkeeper_dialogue, "visible_ratio", 1.0, writing_duration)
	
	dialogue_timer.start()

func _on_dialogue_timer_timeout():
	sprite_3d.visible = false

func _set_emotion(new_emotion: Emotion):
	if new_emotion == Emotion.FRIENDLY:
		region_rect = Rect2(46, 161, 359, 609)
	elif new_emotion == Emotion.SCARED:
		region_rect = Rect2(1392, 0.0, 361, 719)
	elif new_emotion == Emotion.HAPPY:
		region_rect = Rect2(1748, 0, 452, 719)
	elif new_emotion ==Emotion.SURPRISED:
		region_rect = Rect2(2209, 0, 466, 719)
	elif new_emotion == Emotion.HUMBLED:
		region_rect = Rect2(2726, 0, 359, 719)
	elif new_emotion == Emotion.SPOOKED:
		region_rect == Rect2(1645, 712, 356, 693)
	elif new_emotion == Emotion.TIRED:
		region_rect == Rect2(2212, 712, 397, 693)
