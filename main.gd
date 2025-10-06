extends Node2D

@onready var album: Album = $Album
var stamp_scene = preload("res://Album/stamp.tscn")

func _ready():
	connect_boosters()

func connect_stamps():
	# Trouver tous les timbres dans la scène
	var stamps = get_tree().get_nodes_in_group("stamps")
	for stamp in stamps:
		stamp.stamp_clicked.connect(_on_stamp_collected)

func connect_boosters():
	var boosters = get_tree().get_nodes_in_group("boosters")
	for booster in boosters:
		booster.booster_exploded.connect(_on_booster_exploded)

func _on_booster_exploded(booster: Booster):
	spawn_stamps_from_booster(booster.position, 5)
	
func spawn_stamps_from_booster(position: Vector2, nb_stamps: int):
	var spawn_radius = 75.0
	var angle_step = 360.0 / nb_stamps
	
	for i in range(nb_stamps):
		# Calculer position en cercle autour du booster
		var angle = deg_to_rad(i * angle_step)
		var offset = Vector2(cos(angle), sin(angle)) * spawn_radius
		var spawn_pos = position + offset
		
		# Créer un timbre aléatoire
		create_stamp(position + Vector2(50, 50), spawn_pos)

func create_stamp(start_pos, spawn_pos):
	# Récupération d'un id de timbre aléatoirement, en f° de sa rareté
	var rarity = randf()
	var stamp_pool = get_stamps_by_rarity(rarity)
	var stamp_id = stamp_pool.keys()[randi() % stamp_pool.size()]
	var new_stamp = stamp_scene.instantiate()
	
	new_stamp.set_stamp_texture(stamp_pool[stamp_id]["Sprite"])
	# Position de départ (par exemple au-dessus de la position finale)
	new_stamp.position = start_pos  # Ajustez le décalage selon vos besoins
	add_child(new_stamp)
	new_stamp.add_to_group("stamps")
	new_stamp.stamp_id = stamp_id
	# Créer le tween
	var tween = create_tween()
	tween.tween_property(new_stamp, "position", spawn_pos, 0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	# Attendre la fin du tween avant de continuer
	await tween.finished
	# Connecter les signaux après l'animation
	connect_stamps()

func _on_stamp_collected(stamp: Stamp):
	var stamp_id = stamp.stamp_id
	print("Timbre collecté : ", stamp_id)
	
	var target_position = album.get_slot_position(stamp_id)
	target_position.x -= 2
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
	stamp.global_position.x = final_global_pos.x
	stamp.global_position.y = final_global_pos.y
	
	# Maintenant animer vers la position locale (0,0) dans le slot
	var tween = create_tween()
	tween.tween_property(stamp, "position", Vector2(-2,0.0), 0.2)
	
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

func get_stamps_by_rarity(rarity: float):
	var output_rarity = 0
	var output_dict = {}
	
	if rarity <= 0.45:
		output_rarity = 0
	elif rarity <= 0.70:
		output_rarity = 1
	elif rarity <= 0.85:
		output_rarity = 2
	elif rarity <= 0.96:
		output_rarity = 3
	else:
		output_rarity = 4
		
	for stamp_id in global.ALBUM_DICT:
		if global.ALBUM_DICT[stamp_id]['Rarity'] == output_rarity:
			output_dict[stamp_id] = global.ALBUM_DICT[stamp_id]	
	
	return output_dict
		
