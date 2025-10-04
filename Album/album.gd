extends Control
class_name StampAlbum

@onready var ALBUM_DICT = {
	0: $Slot,
	1: $Slot2
}

var COLLECTED_STAMPS: Dictionary = {}

func get_slot_position(stamp_id: int) -> Vector2:
	if ALBUM_DICT.has(stamp_id):
		return ALBUM_DICT[stamp_id].global_position
	return Vector2.ZERO

func mark_stamp_collected(stamp_id: int):
	# Si le carnet ne contient pas encore le timbre, on le rajoute avec son occurence
	if COLLECTED_STAMPS.has(stamp_id) == false:
		COLLECTED_STAMPS[stamp_id] = 1
	# Sinon, on augmente son occurence
	else:
		COLLECTED_STAMPS[stamp_id] += 1

func set_slot_occurency(stamp_id: int):
	var slot: Slot = ALBUM_DICT[stamp_id]
	var occurency = COLLECTED_STAMPS[stamp_id]
	slot.get_node("Label").text = str(occurency)
