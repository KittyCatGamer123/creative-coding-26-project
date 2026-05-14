extends Node3D

@onready var player_raycast: CollisionShape3D = $Player/Head/Camera3D/InteractionDetection/CollisionShape3D
@onready var pointer: AnimatedSprite2D = $CanvasLayer/Hand

func _ready() -> void:
	player_raycast.shape.length = 5

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			pointer.play("point")
		elif not event.pressed:
			pointer.play_backwards("point")
