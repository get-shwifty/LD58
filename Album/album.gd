extends Control
class_name Album

const SLOT_PER_PAGE = 6
const SLOT_MARGE_SIZE_X = 250
const SLOT_MARGE_SIZE_Y = 95
var album_dict = global.ALBUM_DICT
var COLLECTED_STAMPS: Dictionary = {}
var slots = [[]]

var slot_scene = preload("res://Album/slot.tscn")

func _ready():
	var current_page = 0
	var current_page_slot_num = 0
	
	for slot_num in range(album_dict.size()):
		if slot_num % SLOT_PER_PAGE == 0 and slot_num != 0:
			current_page += 1
			slots.append([])
			current_page_slot_num = 0
			
		var new_slot = slot_scene.instantiate()
		slots[current_page].append(new_slot)
		add_child(new_slot)
		
		if current_page_slot_num >= int(SLOT_PER_PAGE) / 2:
			new_slot.position.x = SLOT_MARGE_SIZE_X
		else : 
			new_slot.position.x = 32.0
		new_slot.position.y = SLOT_MARGE_SIZE_Y * ((current_page_slot_num % (SLOT_PER_PAGE / 2)) + 0.27)

		current_page_slot_num += 1
	
	show_page(0)

func show_page(page_num: int):
	for page_number in slots.size():
		var current_slots = slots[page_number]
		for slot in current_slots:
			if page_number == page_num:
				slot.visible = true
			else:
				slot.visible = false
			

func get_page(stamp_id: int) -> int:
	return stamp_id / SLOT_PER_PAGE
	
func get_slot(stamp_id: int) -> Slot:
	return slots[stamp_id / SLOT_PER_PAGE][stamp_id % SLOT_PER_PAGE]

func get_slot_position(stamp_id: int) -> Vector2:
	if album_dict.has(stamp_id):
		return get_slot(stamp_id).global_position
	return Vector2.ZERO

func mark_stamp_collected(stamp_id: int):
	# Si le carnet ne contient pas encore le timbre, on le rajoute avec son occurence
	if COLLECTED_STAMPS.has(stamp_id) == false:
		COLLECTED_STAMPS[stamp_id] = 1
	# Sinon, on augmente son occurence
	else:
		COLLECTED_STAMPS[stamp_id] += 1

func set_slot_occurency(stamp_id: int):
	var slot: Slot = get_slot(stamp_id)
	var description: String = album_dict[stamp_id]["Description"]
	var name: String = album_dict[stamp_id]["Name"]
	var occurrency = COLLECTED_STAMPS[stamp_id]
	
	slot.get_node("Occurrency").text = str("x ", occurrency)
	slot.get_node("Description").text = str(description)
	slot.get_node("Name").text = str(name)
