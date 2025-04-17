@tool
extends Area3D

var hovering: bool = false
var being_taken: bool = false
@export var back_cover: Sprite3D
@export var front_cover: Sprite3D
@export var display: Node3D
@export var card: Card:
	set(new_card):
		card = new_card
		
		if back_cover:
			back_cover.texture = card.back
			front_cover.texture = card.cover

func _ready():
	back_cover.texture = card.back
	front_cover.texture = card.cover
