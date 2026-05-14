extends Node3D

@onready var pointer: AnimatedSprite2D = $CanvasLayer/HandPointer

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			pointer.play("default")
		elif not event.pressed:
			pointer.play_backwards("default")
