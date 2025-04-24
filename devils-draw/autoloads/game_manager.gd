## GAME MANAGER AUTOLOAD
# Manages player and devil information, gets input from other nodes and handles game events.
extends Node

var game : Node3D

enum GameState {
	MAIN_MENU,
	SHOP,
	PLAYING,
	PAUSED
}

@onready var main_theme = $MainTheme
@onready var shop_theme = $ShopTheme
@onready var menu_theme = $MenuTheme

var current_game_state := GameState.MAIN_MENU:
	set(new_val):
		change_game_state(new_val)
		current_game_state = new_val

@onready var music = $BackgroundMusic

# GAME INFO: 0 for player, 1 for devil
@export var game_info : Dictionary = {
	0: {		## PLAYER
		"status_effects": [],
		"hand": [],
		"energy": 50.0,
		"max_energy": 50.0,
		"energy_growth": 1.0,
		"souls": 0,
		"gold": 0,
		"max_gold": 100,
		"health": 5.0,
		"max_health": 5.0,
		"health_growth": 0.0
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
		"max_health": 30.0,
		"health_growth": 0.0
	}
}

var discard_pile : Array[Card] = []

# DEVIL INFO
var time_left : float = 9.0
var game_time_left : float = 7 * 60.0 # once this runs out, the game ends

# PLAYER INFO
var next_hand : Array[Card] = []
var fake_membership : bool = false

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
signal game_end(won: bool)
signal game_start()
signal game_state_change(game_state: GameState)
signal card_played(card: Card, character: int)
signal shop_dialogue(text: String)

func _ready():
	# get game loop node from scene to enact actions.
	game = get_tree().current_scene
	
	dealt_damage.connect(_on_dealt_damage)
	current_game_state = GameState.MAIN_MENU
	main_theme.volume_db = -80.0
	shop_theme.volume_db = -80.0

func _process(delta):
	
	# Debugging
	$Debug.text = ""
	for card in game_info[1]["hand"]:
		$Debug.text += card.title + "\n"
	
	if current_game_state == GameState.MAIN_MENU or current_game_state == GameState.PAUSED: return
	
	# game effects
	for character in range(2):
		
		# status effects
		for effect : StatusEffect in game_info[character]["status_effects"]:
			
			# decrease the time limit on the effect
			effect.time_left -= 1 * delta
			if effect.time_left <= 0:
				#remove effect
				game_info[character]["status_effects"].erase(effect)
				status_effect_change.emit(character, effect, false)
		
		if has_effect(character, StatusEffect.Effects.PARALYZED):
			game_info[character]["energy_growth"] = 0.0
		else:
			game_info[character]["energy_growth"] = 1.0
		
		if has_effect(character, StatusEffect.Effects.BLEEDING):
			game_info[character]["health_growth"] = -0.1
		else:
			game_info[character]["health_growth"] = 0.0
		
		# ENERGY
		if game_info[character]["energy"] <= game_info[character]["max_energy"]:
			game_info[character]["energy"] += game_info[character]["energy_growth"] * delta * game_info[character]["energy_growth"]
		
		# don't let it go below 0
		if game_info[character]["energy"] < 0.0:
			game_info[character]["energy"] = 0.0
		
		# HEALTH
		game_info[character]["health"] += game_info[character]["health_growth"] * delta
		if game_info[character]["health"] < 0 and character == 0:
			player_death()
		elif game_info[character]["health"] < 0 and character == 1:
			game_end.emit(true)
	
	# decrease time
	time_left -= 1 * delta
	
	# if the time limit ends, end the game
	if time_left <= 0 and not current_game_state == GameState.PAUSED:
		current_game_state = GameState.PAUSED
		game_end.emit(false)

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

func has_effect(character: int, effect_type: StatusEffect.Effects) -> bool:
	for e : StatusEffect in game_info[character]["status_effects"]:
		if e.effect_type == effect_type:
			return true
	
	return false

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
	if rarity < 0.73:
		# pick from common cards
		rand_card = common_cards[randi_range(0, len(common_cards)-1)]
	elif rarity < 0.96:
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
	
	# drunken_high
	var energy_amount = card.energy_cost
	if is_drunk(character):
		energy_amount /= 2
	
	# determine if the character has enough energy
	if energy_amount > game_info[character]["energy"]:
		# if doesn't have enough energy
		if character == 0:
			GameManager.not_enough_energy()
		return false
	else:
		# if does have enough energy
		card.play_card(character)
		card_played.emit(card, character)
		GameManager.discard_pile.append(card)
		
		GameManager.deplete_energy(character, energy_amount)
		
		# remove card from hand
		GameManager.game_info[character]["hand"].erase(card)
		
		return true

func add_card(character: int, card: Card):
	game_info[character]["hand"].append(card)
	if character == 0:
		game.ui.hand_display.add_card(card)

func is_drunk(character:int):
	for effect in game_info[character]["status_effects"]:
		if effect.effect_type == StatusEffect.Effects.DRUNKEN_HIGH:
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
	game_info[0]["energy"] = game_info[0]["max_energy"]
	game_info[0]["health"] = game_info[0]["max_health"]
	game_info[1]["hand"] = []
	game_info[0]["status_effects"] = []
	
	# emit signals, 
	player_died.emit()
	time_left = 90.0
	gain_soul()
	print("Player dies")
	game.change_location(game.Locations.SHOP)
	game.cam_speed = 0.5
	await get_tree().create_timer(4.5).timeout
	game.cam_speed = 1.0
	shop_dialogue.emit("player_revived")
	
	# add next hand after death
	for card in next_hand:
		add_card(0, card)
		print('adadijaing caraddd ', card.title)
	next_hand = []

func gain_soul():
	# when the player gets a soul
	#game.change_location(game.Locations.SPIRITS)
	game_info[0]["souls"] += 1
	soul_gained.emit()

func buy_card(card: Card, cost: int):
	# add this card to the next hand.
	
	# half cost if has fake membership
	if fake_membership:
		cost /= 2
	
	# determine if player has enough gold
	if game_info[0]["gold"] >= cost:
		game_info[0]["gold"] -= cost
		var new_card = card.duplicate()
		next_hand.append(new_card)
		print("bought item")
		shop_dialogue.emit("player_buys")
		
		# remove fake membership
		fake_membership = false
	else:
		print('not enough gold')
		shop_dialogue.emit("not_enough_gold")

func change_game_state(new_state: GameState):
	# change music
	if new_state != current_game_state:
		var tween = get_tree().create_tween().set_parallel()
		# tone down current music
		if current_game_state == GameState.MAIN_MENU:
			tween.tween_property(menu_theme, "volume_db", -80.0, 5.0)
		if current_game_state == GameState.SHOP:
			tween.tween_property(shop_theme, "volume_db", -80.0, 5.0)
		if current_game_state == GameState.PLAYING:
			tween.tween_property(main_theme, "volume_db", -80.0, 5.0)
		
		# ramp up new music
		if new_state == GameState.MAIN_MENU:
			tween.tween_property(menu_theme, "volume_db", 0.0, 1.0)
		if new_state == GameState.SHOP:
			tween.tween_property(shop_theme, "volume_db", 0.0, 1.0)
		if new_state == GameState.PLAYING:
			tween.tween_property(main_theme, "volume_db", 0.0, 1.0)
	
	game_state_change.emit(current_game_state)
