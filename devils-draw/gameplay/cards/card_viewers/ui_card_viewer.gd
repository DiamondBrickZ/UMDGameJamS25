@tool
extends Area2D

@export var base_scale : float = 1.0

var can_hover = true
var hovering = false:
	set(new_val):
		hovering = new_val
		
		#if can_hover:
			#if hovering:
				#var tween = get_tree().create_tween()
				#tween.tween_property(self, "scale", Vector2(base_scale*1.1, base_scale*1.1), 0.4).set_trans(Tween.TRANS_SINE)
			#else:
				#var tween = get_tree().create_tween()
				#tween.tween_property(self, "scale", Vector2(base_scale, base_scale), 0.4).set_trans(Tween.TRANS_SINE)

var target_position : Vector2
var target_rotation : float
var picked = false
var hand_display : Control
@onready var display = $Display
@onready var border = $Border
@onready var anim_player = $AnimationPlayer
@onready var mouse_detection = $MouseDetection
@onready var title = $Title
@onready var description = $Description
@onready var energy_cost = $MeshInstance2D/EnergyCost
@onready var blur = $Blur


@export var card : Card:
	set(new_card):
		card = new_card
		
		if display:
			refresh()
@export var size: float = 1.5:
	set(new_val):
		size = new_val
		
		if display:
			refresh()

@export var refresh_button : bool = false:
	set(new_val):
		refresh_button = false
		refresh()

@export_group("References")
@export var common_border : CompressedTexture2D
@export var rare_border : CompressedTexture2D
@export var super_rare_border : CompressedTexture2D

func _ready():
	hand_display = get_parent().get_parent()
	GameManager.card_played.connect(_on_card_played)
	GameManager.status_effect_change.connect(_on_status_effect_change)
	refresh()

func _on_status_effect_change(character: int, effect: StatusEffect, applied: bool):
	if character == 0 and effect.effect_type == StatusEffect.Effects.TIPSY:
		if applied:
			blur.visible = true
		else:
			blur.visible = false

func _on_card_played(new_card:Card, character:int):
	if new_card == card and character == 0:
		#print('playing ', new_card.title)
		play_card_animation()

func _on_mouse_entered():
	hovering = true
	if not picked:
		hand_display.selected_card = self

func _on_mouse_exited():
	hovering = false
	await get_tree().create_timer(0.1).timeout
	if not picked:
		if hand_display.selected_card == self:
			hand_display.selected_card = null

func _on_input_event(viewport, event, shape_idx):
	#if Input.is_action_just_pressed("inspect") and hovering:
		#inspect_card()
	if Input.is_action_just_pressed("action") and not picked:
		var id = hand_display.get_card_viewer_index(self)
		if GameManager.play_card(0, card, id):
			GameManager.devil_turn()

func play_card_animation():
	var screen_size = get_viewport_rect().size
	picked = true
	reparent(get_tree().current_scene.ui)
	self.z_index = 10000
	can_hover = false
	
	# animate it enlargening in middle of screen and then disappearing
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property(self, "position", Vector2(screen_size.x/2,3*screen_size.y/2), 0.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "scale", Vector2(3,3), 1).set_trans(Tween.TRANS_SINE)
	
	await get_tree().create_timer(1).timeout
	$AnimationPlayer.play("play_card")
	
	await get_tree().create_timer(1).timeout
	queue_free()

func _process(delta):
	if not picked:
		position = lerp(position, target_position, 0.1)
		rotation = lerp(rotation, target_rotation, 0.1)

func refresh():
	# set card textures
	display.texture = card.cover
	if card.card_rarity == Card.Rarity.COMMON:
		border.texture = common_border
	elif card.card_rarity == Card.Rarity.RARE:
		border.texture = rare_border
	else:
		border.texture = super_rare_border
	
	# set card text
	title.text = card.title
	description.text = card.desc
	energy_cost.text = str(int(card.energy_cost))
	
	# set size
	#mouse_detection.shape.size = border.texture.get_size()
	mouse_detection.scale = Vector2(size, size)
	#display.scale = Vector2(size, size)
	mouse_detection.scale = Vector2(size, size)
