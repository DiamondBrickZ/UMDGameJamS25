@tool
extends Area3D

var hovering: bool = false
var being_taken: bool = false
@export var back_cover: Sprite3D
@export var front_border: Sprite3D
@export var front_icon: Sprite3D
@export var display: Node3D
@export var card: Card:
	set(new_card):
		card = new_card
		
		if back_cover:
			refresh()

@export_group("References")
@export var common_border : CompressedTexture2D
@export var rare_border : CompressedTexture2D
@export var super_rare_border : CompressedTexture2D

func _ready():
	refresh()

func refresh():
	back_cover.texture = card.back
	front_icon.texture = card.cover
	
	if card.card_rarity == Card.Rarity.COMMON:
		front_border.texture = common_border
	elif card.card_rarity == Card.Rarity.RARE:
		front_border.texture = rare_border
	else:
		front_border.texture = super_rare_border
