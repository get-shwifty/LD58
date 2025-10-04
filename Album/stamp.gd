extends Area2D
class_name Stamp

@export var stamp_id: int = 0

signal stamp_clicked(stamp_id)

func _ready():
	# Connecter le signal d'entrée
	input_event.connect(_on_input_event)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("stamp_clicked", self)

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		emit_signal("stamp_clicked", self)

func set_stamp_texture(texture: Texture2D):
	if $Sprite:
		$Sprite.texture = texture
