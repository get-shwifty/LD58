extends Node2D

@onready var album = $Album
@onready var stamp1 = $Stamp
@onready var stamp2 = $Stamp2

var sprite_stamp1 = preload("res://Assets/stamps/lumiere.png")
var sprite_stamp2 = preload("res://Assets/stamps/nevaries.png")
var sprite_stamp3 = preload("res://Assets/stamps/pharloom.png")
var sprite_stamp4 = preload("res://Assets/stamps/rapture.png")
var sprite_stamp5 = preload("res://Assets/stamps/irithil.png")

func _ready():
	$Stamp1.set_stamp_texture(sprite_stamp1)
	$Stamp2.set_stamp_texture(sprite_stamp2)
	$Stamp3.set_stamp_texture(sprite_stamp3)
	$Stamp4.set_stamp_texture(sprite_stamp4)
	$Stamp5.set_stamp_texture(sprite_stamp5)
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
	animate_stamp_to_slot(stamp, target_position)
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
	
	# Mise à jour du nb d'occurence
	
