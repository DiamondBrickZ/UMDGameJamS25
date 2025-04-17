extends Control

@export var dark_noise : ColorRect
@export var damage_effects : ColorRect
@export var anim_player : AnimationPlayer

var is_dying : bool = false

func _ready():
	GameManager.game_end.connect(_on_game_end)
	GameManager.dealt_damage.connect(_on_dealt_damage)
	GameManager.player_died.connect(_on_player_died)

func _process(delta):
	
	if not is_dying:
		dark_noise.material.set("shader_parameter/radius", remap(GameManager.time_left, 60.0, 0.0, 0.0, 1.5))

func _on_player_died():
	is_dying = true
	anim_player.play("player_death")
	await get_tree().create_timer(2.5).timeout
	is_dying = false

func _on_dealt_damage(character: int, amount: float):
	if character == 0 and not is_dying:	# if player
		anim_player.play("player_damaged")

func _on_game_end():
	_on_player_died()
