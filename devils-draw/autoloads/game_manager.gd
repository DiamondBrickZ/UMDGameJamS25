## GAME MANAGER AUTOLOAD
# Manages player and devil information, gets input from other nodes and handles game events.
extends Node

var game_loop : Node3D

# DEVIL INFO
var devil_status_effects : Array[StatusEffect] = []
var devil_hand : Array[Card] = []
var devil_energy : float = 10.0
var devil_health : float = 20.0
var time_left : float = 60.0

# PLAYER INFO
var player_status_effects : Array[StatusEffect] = []
var player_energy : float = 0.0
var player_energy_max : float = 10.0
var player_health : float = 5.0
var player_souls : int = 0
var player_gold : int = 0

# CARDS
@export var available_cards : Array[Card] = []

# SIGNALS
signal card_drawn(card: Card, character: int)	# 0 for player, 1 for devil

func _ready():
	# get game loop node from scene to enact actions.
	game_loop = get_tree().current_scene

func _process(delta):
	player_energy += 0.1 * delta
	time_left -= 1 * delta

func draw_card(character: int = 0):
	# choose random card from pile, remove it from pile and give it to player
	# returns card chosen
	var rand_card : Card = available_cards.pop_at(randi_range(0, len(available_cards)-1))
	if rand_card:
		game_loop.draw_card(rand_card, character)
		
		# this is an action, so make the devil play a turn too
		if character == 0:
			devil_turn()
		else:
			devil_hand.append(rand_card)
		
		card_drawn.emit(rand_card, character)
	else:
		print("no more cards left")

func play_card(card: Card, index : int):
	# play a card action
	if card.play_card():
		# if the card does have an action, then proceed
		devil_turn()
		return true
	else:
		return false

func devil_turn():
	# The devil plays his turn
	
	# for now, just draw a card
	draw_card(1)

func deplete_energy(amount: float):
	player_energy -= amount

func not_enough_energy():
	# little animation to show there's not enough energy to play a card
	var tween = get_tree().create_tween()
	game_loop.ui.ui_animations.play("not_enough_energy")

func player_death():
	# player dies
	pass
