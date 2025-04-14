extends ColorRect

@export var anim_player : AnimationPlayer

func _ready():
	GameManager.dealt_damage.connect(_on_dealt_damage)

func _on_dealt_damage(character: int, amount: float):
	if character == 0:	# if player
		anim_player.play("player_damaged")
