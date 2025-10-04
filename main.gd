extends Node2D

@onready var album: Album = $Album
var stamp_scene = preload("res://Album/stamp.tscn")

func _ready():
	for stamp_id in global.ALBUM_DICT:
		var new_stamp = stamp_scene.instantiate()
		new_stamp.set_stamp_texture(global.ALBUM_DICT[stamp_id]["Sprite"])
		add_child(new_stamp)
		new_stamp.add_to_group("stamps")
		new_stamp.stamp_id = stamp_id
	# Connecter les signaux des timbres disponibles
	connect_stamps()

func connect_stamps():
	# Trouver tous les timbres dans la scène
	var stamps = get_tree().get_nodes_in_group("stamps")
	for stamp in stamps:
		stamp.stamp_clicked.connect(_on_stamp_collected)

func _on_stamp_collected(stamp: Stamp):
	var stamp_id = stamp.stamp_id
	print("Timbre collecté : ", stamp_id)
	
	var target_position = album.get_slot_position(stamp_id)
	var target_slot = album.get_slot(stamp_id)
	var target_page = album.get_page(stamp_id)
	
	album.show_page(target_page)
	await animate_stamp_to_slot(stamp, target_position)
	
	# Sauvegarder la position globale AVANT le reparentage
	var final_global_pos = stamp.global_position
	
	# Reparenter
	stamp.get_parent().remove_child(stamp)
	target_slot.add_child(stamp)
	
	# Restaurer la position globale APRÈS le reparentage
	stamp.global_position = final_global_pos
	
	# Maintenant animer vers la position locale (0,0) dans le slot
	var tween = create_tween()
	tween.tween_property(stamp, "position", Vector2.ZERO, 0.2)
	
	album.mark_stamp_collected(stamp_id)
	album.set_slot_occurency(stamp_id)
	
	
func animate_stamp_to_slot(stamp: Stamp, target_position: Vector2):
	var tween = create_tween()
	tween.set_parallel(true)
	
	# Déplacement
	tween.tween_property(stamp, "global_position", target_position, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	# Petit effet de scale pendant le déplacement
	tween.tween_property(stamp, "scale", Vector2(1.2, 1.2), 0.25)
	tween.chain().tween_property(stamp, "scale", Vector2(1.0, 1.0), 0.25)
	
	await tween.finished
