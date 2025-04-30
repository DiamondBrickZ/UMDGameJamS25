extends Control

@export var anim_player : AnimationPlayer
@onready var v_box_container = $Control/PanelContainer/MarginContainer/VBoxContainer

var menu_item = preload("res://scenes/shopkeeper/shop/menu_item.tscn")

@export var num_options = 5

@export var options : Array[Card] = []

func populate_menu():
	
	# remove existing items
	for i in v_box_container.get_children():
		i.queue_free()
	
	# create duplicate list
	var list : Array[Card] = options.duplicate()
	
	# get all cards
	var files = GameManager.get_all_file_paths("res://gameplay/cards/")
	var card_resources = []
	for file in files:
		if file.ends_with(".tres"):		# if its a resource
			card_resources.append(file)
	
	# load all cards
	var cards = []
	for file in card_resources:
		cards.append(ResourceLoader.load(file))
	
	# TODO create general pick card function in game maanger
	
	for i in range(num_options):
		var new_item = menu_item.instantiate()
		var rand_card : Card = cards.pick_random()
		#list.remove_at(rand_card)		# prevent from choosing the same one
		var gold_cost : int = int(rand_card.energy_cost/2)
		var item_name : String = rand_card.title + " (Cost: " + str(gold_cost) + ")"
		new_item.text = item_name
		v_box_container.add_child(new_item)
		new_item.pressed.connect(_on_menu_item_pressed.bind(rand_card, gold_cost))

func _on_menu_item_pressed(card: Card, cost: float):
	GameManager.buy_card(card, cost)

func _ready():
	GameManager.player_died.connect(_on_player_died)
	populate_menu()

func _on_player_died():
	populate_menu()

func slide_in():
	anim_player.play("slide_in")

func slide_out():
	anim_player.play("slide_in", -1, -1.0, true)
