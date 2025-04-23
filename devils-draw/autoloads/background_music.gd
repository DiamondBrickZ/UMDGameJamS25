extends AudioStreamPlayer

@export var main_menu_music: AudioStreamOggVorbis
@export var playing_music: AudioStreamOggVorbis

func _ready():
	bus = &"BackgroundMusic"
	GameManager.game_state_change.connect(_on_game_state_change)
	_on_game_state_change(GameManager.GameState.MAIN_MENU)

func _on_game_state_change(game_state):
	if game_state == GameManager.GameState.MAIN_MENU:
		stream = main_menu_music
		play()
	else:
		stream = playing_music
		play()
