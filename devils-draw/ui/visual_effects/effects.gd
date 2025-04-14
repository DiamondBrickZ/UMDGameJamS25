extends Control

@export var dark_noise : ColorRect
@export var damage_effects : ColorRect
@export var anim_player : AnimationPlayer

func _ready():
	GameManager.game_end.connect(_on_game_end)
	GameManager.dealt_damage.connect(_on_dealt_damage)

func _process(delta):
	
	dark_noise.material.set("shader_parameter/radius", remap(GameManager.time_left, 60.0, 0.0, 0.0, 1.5))

func _on_dealt_damage(character: int, amount: float):
	if character == 0:	# if player
		anim_player.play("player_damaged")

func _on_game_end():
	var tween = get_tree().create_tween()
	tween.tween_property(dark_noise.material, "shader_parameter/radius", 100.0, 1.0)
	#dark_noise.material.set("shader_parameter/radius", 10.0)
