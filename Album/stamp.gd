extends Area2D
class_name Stamp

@export var stamp_id: int = 0

signal stamp_clicked(stamp)

func _ready():
	# Connecter le signal d'entrée
	input_event.connect(_on_input_event)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("stamp_clicked", self)
		get_viewport().set_input_as_handled()

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		emit_signal("stamp_clicked", self)

func set_stamp_texture(texture: Texture2D):
	# Créer ou récupérer l'AnimatedSprite2D
	var animated_sprite: AnimatedSprite2D = $Sprite
	
	# Créer les SpriteFrames
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_animation("default")
	
	# Calculer le nombre de frames (largeur totale / 40px)
	var frame_width = 44
	var frame_height = texture.get_height()
	var frame_count = int(texture.get_width() / frame_width)
	
	# Créer une AtlasTexture pour chaque frame
	for i in range(frame_count):
		var atlas = AtlasTexture.new()
		atlas.atlas = texture
		atlas.region = Rect2(i * frame_width, 0, frame_width, frame_height)
		sprite_frames.add_frame("default", atlas)
	
	# Appliquer les frames à l'AnimatedSprite
	animated_sprite.sprite_frames = sprite_frames
	
	# Si une seule frame, ne pas animer, sinon lancer l'animation
	if frame_count == 1:
		animated_sprite.stop()
		animated_sprite.frame = 0
	else:
		animated_sprite.play("default")
