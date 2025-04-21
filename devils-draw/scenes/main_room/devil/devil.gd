@tool
extends Sprite3D
class_name Devil

enum States {
	FOCUSED,
	AGGRESSIVE,
	EGO,
	DAMAGED,
	RISKY,
	BIG
}

@export var devil_dialogue : RichTextLabel
@export var dialogue_sprite_3d : Sprite3D
@export var dialogue_timer : Timer

@export var current_emotion := States.AGGRESSIVE:
	set(new_val):
		current_emotion = new_val
		
		refresh()

@export var writing_duration : float = 1.5

@export var quip_taken_damage : Array[String] = [
	"That tickled.",
	"You know it'll take more than that to beat me."
]

func _ready():
	GameManager.dealt_damage.connect(_on_dealt_damage)
	GameManager.status_effect_change.connect(_on_status_effect_change)

func _on_status_effect_change(character: int, effect: StatusEffect, applied: bool):
	if character == 1 and applied:
		if effect.effect_type == StatusEffect.Effects.BURNING:
			write_dialogue("burning")
		elif effect.effect_type == StatusEffect.Effects.PARALYZED:
			write_dialogue("paralyzed")
		elif effect.effect_type == StatusEffect.Effects.BLEEDING:
			write_dialogue("bleeding")
		elif effect.effect_type == StatusEffect.Effects.POISONED:
			write_dialogue("poisoned")
		elif effect.effect_type == StatusEffect.Effects.DRUNKEN_HIGH:
			write_dialogue("drunken_high")
		elif effect.effect_type == StatusEffect.Effects.HASTE:
			write_dialogue("haste")

func _on_dealt_damage(character: int, amount: float):
	if character == 1:
		var quip_chance = randf()
		if quip_chance > 0.7:
			write_dialogue("taken_damage")

func refresh():
	if current_emotion == States.FOCUSED:
		region_rect = Rect2(118, 0, 754, 1339)
	elif current_emotion == States.AGGRESSIVE:
		region_rect = Rect2(897, 0, 688, 1339)
	elif current_emotion == States.EGO:
		region_rect = Rect2(2392, 0, 725, 1371)
	elif current_emotion == States.DAMAGED:
		region_rect = Rect2(1622, 0, 732, 1371)
	elif current_emotion == States.RISKY:
		region_rect = Rect2(3125, 0, 680, 1371)
	elif current_emotion == States.BIG:
		region_rect = Rect2(31, 1419, 1953, 1280)

func write_dialogue(text: String):
	var text_to_write : String = ""
	if text == "taken_damage":
		text_to_write = quip_taken_damage.pick_random()
	elif text == "burning":
		text_to_write = "Y'know, this is pretty dumb. I literally control fire."
	elif text == "paralyzed":
		text_to_write = "I *shock* really *shock* hate *shock* this!!! *shock*"
	elif text == "bleeding":
		text_to_write = "Are you surprised? Even I bleed. Oh, trust me it doesn’t really hurt, but it is certainly annoying."
	elif text == "poisoned":
		text_to_write = "You dare poison me? Heh. Fine, no mere toxin can stop me."
	elif text == "drunken_high":
		text_to_write = "Hahahahaha. This is so fun. C-Come on, let’s keep going."
	elif text == "haste":
		text_to_write = "haste"
	
	
	devil_dialogue.text = text_to_write
	dialogue_sprite_3d.visible = true
	
	# animate writing
	devil_dialogue.visible_ratio = 0.0
	var tween = get_tree().create_tween()
	tween.tween_property(devil_dialogue, "visible_ratio", 1.0, writing_duration)
	
	dialogue_timer.start()

func _on_dialogue_timer_timeout():
	dialogue_sprite_3d.visible = false
