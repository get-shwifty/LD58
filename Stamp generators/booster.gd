extends Area2D
class_name Booster

@onready var sprite = $Icon
@onready var particles = $CPUParticles2D

signal booster_exploded(booster: Booster)

func _ready():
	input_event.connect(_on_input_event)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		explode()

func explode():
	# Animation d'explosion
	# var tween = create_tween()
	# tween.set_parallel(true)
		
	$AnimatedSprite2D.play()
	await $AnimatedSprite2D.animation_finished
	# Grossir puis disparaître
	# tween.tween_property(sprite, "scale", Vector2(2.0, 2.0), 0.4)
	# tween.tween_property(sprite, "modulate:a", 0.0, 0.4)
	
	# Burst de particules
	if particles:
		particles.amount = 30
		particles.emitting = true
		
	await particles.finished
	emit_signal("booster_exploded", self)
	
	queue_free()
