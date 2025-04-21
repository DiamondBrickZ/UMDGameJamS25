## STATUS EFFECT RESOURCE
extends Resource
class_name StatusEffect

enum Effects {
	BURNING,
	BLEEDING,
	POISONED,
	TIPSY,
	PARALYZED,
	HASTE,
	DRUNKEN_HIGH,
	EXTRA_DAMAGE
}

enum Tag {
	NEGATIVE,
	POSITIVE
}

@export var stacking : bool = false
@export var effect_icon : CompressedTexture2D
@export var effect_type : Effects
@export var status_name: String
@export var status_desc: String
@export var effect_tag : Tag
var time_left : float
