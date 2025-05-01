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

var intro : Array[String] = [
	"H-Hey friend! How’s the head?",
	"By the way, y-you’re, uh, dead. P-pretty nasty crash there.",
	"The Boss has taken an interest in you.",
	"He’s giving you the opportunity to play a little card game with him…",
	"B-Before he tortures you for eternity, of course.",
	"You [b]draw[/b] cards, [b]play cards[/b], [b]deal damage[/b] to each other, and so on until one of you runs out of health.",
	"Different cards have different effects. Don’t worry, you’ll figure it out as you go on.",
	"Playing certain cards takes up energy. You can’t play if you run out.",
	"You can also earn coins, which you can spend on my shop here to get cards!",
	"Well, cards for next time. Not this round.",
	"‘Next time?’ I hear you ask, well…",
	"D-don’t tell anyone, but I’ve always thought he’s been too cocky.",
	"The devil’s giving himself one life.",
	"You defeat him? He’s one-and-done.",
	"You, however, can play all you want.",
	"When you run out of health, you’ll wake back up here. Um, nowhere else to go when you’re already dead, heh.",
	"Death resets your hand and your gold.",
	"However, whenever you die, you receive a bit of soul. I-it’s in a bottle right on the table inside.",
	"You can spend souls to receive permanent buffs.",
	"Sounds great, right? W-Well…",
	"One small, uh, caveat.",
	"See that timer? That’s how long you have until your body up there croaks.",
	"That runs out, you lose permanently.",
	"But, of course, Death resets the timer, as well.",
	"A-Anyway, if you somehow manage to win, he’ll let go back to your body.",
	"Well, that’s about all. Uh, good luck, my friend!",
	"(...You remind me a lot of Sisyphus.)"
]

var intro_i : int = 100000

@export var writing_duration : float = 1.5

func _ready():
	sprite_3d.visible = false
	GameManager.shop_dialogue.connect(write_dialogue)
	if GameManager.do_tutorial:
		intro_i = 0

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
	elif text == "intro":
		text_to_write = intro[intro_i]
		intro_i += 1
	
	shopkeeper_dialogue.text = text_to_write
	sprite_3d.visible = true
	
	# animate writing
	shopkeeper_dialogue.visible_ratio = 0.0
	var tween = get_tree().create_tween()
	tween.tween_property(shopkeeper_dialogue, "visible_ratio", 1.0, writing_duration)
	
	dialogue_timer.start()

func _on_dialogue_timer_timeout():
	sprite_3d.visible = false
	if intro_i < len(intro):
		await get_tree().create_timer(1).timeout
		write_dialogue("intro")
	else:
		GameManager.current_game_state = GameManager.GameState.SHOP

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
