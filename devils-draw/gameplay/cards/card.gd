extends Resource
class_name Card

@export var title: String
@export var desc: String
@export var cover: CompressedTexture2D
@export var energy_cost: float

@export var card_actions : Array[CardAction] = []

enum Type {
	ATTACK,
	DEFENSE
}

enum Method {
	INSTANT,
	ACTION,
	PASSIVE
}

enum Rarity {
	COMMON,
	RARE,
	SUPER_RARE
}

var back : CompressedTexture2D

@export var card_rarity := Rarity.COMMON:
	set(new_val): 
		card_rarity = new_val
		
		if card_rarity == Rarity.COMMON:
			back = common_rarity_back
		elif card_rarity == Rarity.RARE:
			back = rare_rarity_back

@export var card_method := Method.ACTION

var common_rarity_back : CompressedTexture2D = load("res://gameplay/cards/test_back.png")
var rare_rarity_back : CompressedTexture2D = load("res://gameplay/cards/test_back.png")

func get_card_type() -> Type:
	for action : CardAction in card_actions:
		if action is CardActionDamage:
			return Type.ATTACK
	
	return Type.DEFENSE

func play_card(character: int = 0):
	# play all card actions
	for card_action in card_actions:
		card_action.do_action(character)
