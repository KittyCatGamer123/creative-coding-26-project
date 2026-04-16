@tool
extends Character
class_name Player

@export var sensitivity: float = 0.005
@onready var player_camera: Camera3D = $Head/Camera3D

func _ready():
	if not Engine.is_editor_hint():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if not Engine.is_editor_hint():
		if event.is_action_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		elif event is InputEventMouseMotion:
			rotate_y(-event.relative.x * sensitivity)
			player_camera.rotate_x(-event.relative.y * sensitivity)
			player_camera.rotation.x = clamp(player_camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
