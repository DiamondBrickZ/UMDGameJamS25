extends Resource
class_name SpiritOption

enum Type {
	HEALTH,
	GOLD,
	DAMAGE,
	SHIELD,
	SOUL
}

@export var type := Type.HEALTH
@export var display : String = ""
@export var description : String = ""
@export var soul_cost: int = 0
