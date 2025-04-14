## GAME MANAGER AUTOLOAD
# Manages player and devil information, gets input from other nodes and handles game events.
extends Node

var game : Node3D

# GAME INFO: 0 for player, 1 for devil
@export var game_info : Dictionary = {
	0: {		## PLAYER
		"status_effects": [],
		"hand": [],
		"energy": 50.0,
		"max_energy": 50.0,
		"energy_growth": 0.8,
		"souls": 0,
		"gold": 0,
		"max_gold": 100,
		"health": 5.0,
		"max_health": 5.0
	},
	1: {		## DEVIL
		"status_effects": [],
		"hand": [],
		"energy": 50.0,
		"max_energy": 50.0,
		"energy_growth": 1.0,
		"souls": 0,
		"gold": 0,
		"max_gold": 100,
		"health": 30.0,
		"max_health": 30.0
	}
}

# DEVIL INFO
var time_left : float = 60.0	# 7 minutes

# PLAYER INFO

# CARDS
@export var available_cards : Array[Card] = []

@export_group("Devil Strategy")
@export_range(0, 1) var aggressiveness : float = 1.0
@export_range(0, 1) var ego : float = 1.0
@export_range(0, 1) var focus : float = 1.0
@export_range(0, 1) var riskiness : float = 1.0

# SIGNALS
signal card_drawn(card: Card, character: int)	# 0 for player, 1 for devil
signal soul_gained()
signal failed_move()
signal status_effect_change(character: int, effect: StatusEffect, applied: bool)
signal dealt_damage(character: int, amount: float)
signal player_died()
signal game_end()
signal card_played(card: Card, character: int)

func _ready():
	# get game loop node from scene to enact actions.
	game = get_tree().current_scene
	
	dealt_damage.connect(_on_dealt_damage)

func _process(delta):
	
	# Debugging
	$Debug.text = ""
	for card in game_info[1]["hand"]:
		$Debug.text += card.title + "\n"
	
	# grow energy levels
	for character in range(2):
		
		# determine if the character has paralysis effect
		var has_paraylsis = false
		var has_bleeding = false
		for effect : StatusEffect in game_info[character]["status_effects"]:
			if effect.effect_type == StatusEffect.Effects.PARALYZED:
				has_paraylsis = true
			elif effect.effect_type == StatusEffect.Effects.BLEEDING:
				has_bleeding = true
		
		# otherwise, grow energy
		if not has_paraylsis:
			# increase energy levels
			if game_info[character]["energy"] <= game_info[character]["max_energy"]:
				game_info[character]["energy"] += game_info[character]["energy_growth"] * delta
			
			# don't let it go below 0
			if game_info[character]["energy"] < 0.0:
				game_info[character]["energy"] = 0.0
		
		# if bleeding, slowly drain health
		if has_bleeding:
			game_info[character]["health"] -= 0.1 * delta
			if game_info[character]["health"] < 0 and character == 0:
				player_death()
			elif game_info[character]["health"] < 0 and character == 1:
				game_end.emit()
	
	# decrease time
	time_left -= 1 * delta
	
	# if the time limit ends, end the game
	if time_left <= 0:
		game_end.emit()
	
	# status effects
	for character in range(2):
		for effect : StatusEffect in game_info[character]["status_effects"]:
			
			# decrease the time limit on the effect
			effect.time_left -= 1 * delta
			if effect.time_left <= 0:
				#remove effect
				game_info[character]["status_effects"].erase(effect)
				status_effect_change.emit(character, effect, false)
			#do_status_effect(character, effect, delta)

func _on_dealt_damage(character: int, _amount: float):
	if game_info[character]["health"] <= 0:
		if character == 0:
			# player dies
			player_death()
		else:
			# win game
			pass

func apply_status_effect(character: int, effect: StatusEffect):
	
	# if no stacking, then remove existing effects of same type
	if not effect.stacking:
		for e : StatusEffect in game_info[character]["status_effects"]:
			if e.effect_type == effect.effect_type:
				game_info[character]["status_effects"].erase(e)
	
	# otherwise, add the effect even if it already exists.
	game_info[character]["status_effects"].append(effect)
	status_effect_change.emit(character, effect, true)

#func do_status_effect(character: int, effect: StatusEffect, delta):
	#if effect.effect_type == StatusEffect.Effects.PARALYZED:
	#

func get_all_file_paths(path: String) -> Array[String]:  
	var file_paths: Array[String] = []  
	var dir = DirAccess.open(path)  
	dir.list_dir_begin()  
	var file_name = dir.get_next()  
	while file_name != "":  
		var file_path = path + "/" + file_name  
		if dir.current_is_dir():  
			file_paths += get_all_file_paths(file_path)  
		else:  
			file_paths.append(file_path)  
		file_name = dir.get_next()  
	return file_paths

func draw_card(character: int = 0):
	
	var files = get_all_file_paths("res://gameplay/cards/")
	var card_resources = []
	for file in files:
		if file.ends_with(".tres"):		# if its a resource
			card_resources.append(file)
	
	# load all cards
	var cards = []
	for file in card_resources:
		cards.append(ResourceLoader.load(file))
	
	# choose card rarity
	var rarity = randf()
	var common_cards : Array[Card]
	var rare_cards : Array[Card]
	var super_rare_cards : Array[Card]
	for card : Card in cards:
		if card.card_rarity == Card.Rarity.COMMON:
			common_cards.append(card)
		elif card.card_rarity == Card.Rarity.RARE:
			rare_cards.append(card)
		else:
			super_rare_cards.append(card)
	
	# pick card
	var rand_card : Card
	if rarity < 0.75:
		# pick from common cards
		rand_card = common_cards[randi_range(0, len(common_cards)-1)]
	elif rarity < 0.98:
		rand_card = rare_cards[randi_range(0, len(rare_cards)-1)]
	else:
		rand_card = super_rare_cards[randi_range(0, len(super_rare_cards)-1)]
	
	# create card and add it to game
	var new_card : Card = rand_card.duplicate()
	game_info[character]["hand"].append(new_card)
	card_drawn.emit(new_card, character)
	
	await get_tree().create_timer(0.5).timeout
	
	# run instant action if there is any
	if new_card.card_method == Card.Method.INSTANT:
		play_card(character, new_card, len(game_info[character]["hand"])-1)

func play_card(character: int, card: Card, _index : int):
	# play a card action
	
	# determine if the character has enough energy
	if card.energy_cost > game_info[character]["energy"]:
		# if doesn't have enough energy
		if character == 0:
			GameManager.not_enough_energy()
		return false
	else:
		# if does have enough energy
		card.play_card(character)
		card_played.emit(card, character)
		
		# if in drunken high, deplete half energy
		var energy_depletion = card.energy_cost
		for effect in game_info[character]["status_effects"]:
			if effect.effect_type == StatusEffect.Effects.DRUNKEN_HIGH:
				energy_depletion = card.energy_cost/2
		GameManager.deplete_energy(character, energy_depletion)
		
		# remove card from hand
		GameManager.game_info[character]["hand"].erase(card)
		
		return true

func deal_damage(character: int, amount: float):
	# deals damage to character specified
	game_info[character]["health"] -= amount
	dealt_damage.emit(character, amount)

func devil_turn():
	# The devil plays his turn
	var attack_cards = []
	var defense_cards = []
	
	# get all cards
	for index in range(len(game_info[1]["hand"])):
		var card : Card = game_info[1]["hand"][index]
		for card_action in card.card_actions:
			if card_action is CardActionDamage:
				attack_cards.append(index)
			else:
				defense_cards.append(index)
	
	var attack_urge = aggressiveness * len(attack_cards)/(len(attack_cards) + 1)
	print("attack urge = " + str(attack_urge))
	
	if attack_urge >= 0.5:
		# attack!!
		
		var found_card : int
		for i in attack_cards:
			if game_info[1]["hand"][i].energy_cost < game_info[1]["energy"]:
				found_card = i
		
		if not found_card:
			print('not enough energy for any move!!')
			# if not enough energy, then draw a new card
			draw_card(1)
		#var rand_i = randi_range(0, len(attack_cards)-1)
		#var rand_card = attack_cards[rand_i]
		play_card(1, game_info[1]["hand"][found_card], found_card)
	else:
		draw_card(1)

func deplete_energy(character: int, amount: float):
	
	# if not, then deplete energy
	game_info[character]["energy"] -= amount

func not_enough_energy():
	# little animation to show there's not enough energy to play a card
	failed_move.emit()

func player_death():
	# player ded
	game_info[0]["gold"] = 0.0
	game_info[0]["energy"] = 0.0
	game_info[0]["health"] = game_info[0]["max_health"]
	game_info[0]["hand"] = []
	game_info[1]["hand"] = []
	player_died.emit()
	time_left = 90.0
	gain_soul()
	print("Player dies")

func gain_soul():
	# when the player gets a soul
	game.change_location(game.Locations.SPIRITS)
	await get_tree().create_timer(1).timeout
	game_info[0]["souls"] += 1
	soul_gained.emit()
