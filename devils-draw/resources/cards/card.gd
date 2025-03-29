extends Resource
class_name Card

@export var title: String
@export var desc: String
@export var cover: CompressedTexture2D
@export var back: CompressedTexture2D
@export var energy_cost: float

enum CARD_TYPES {
	INSTANT,
	ACTION,
	PASSIVE
}

@export var card_type := CARD_TYPES.ACTION

func play_card():
	# no default action, so return false
	return false

func instant_effect():
	# no default instant effect, so return false
	return false
