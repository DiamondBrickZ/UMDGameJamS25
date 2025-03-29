## COIN BAG CARD
extends Card
class_name CoinBag

@export var gold_amount : int = 5

func play_card():
	# condition: enough energy?
	if GameManager.player_energy >= energy_cost:
		print("gaining 5 gold!")
		GameManager.player_gold += gold_amount
		GameManager.deplete_energy(energy_cost)
		return true
	else:
		GameManager.not_enough_energy()
		return false
