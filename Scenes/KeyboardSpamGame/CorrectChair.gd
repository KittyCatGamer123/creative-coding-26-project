extends Interactable

func _ready() -> void:
	body_mesh = $CorrectChair.material_override

func player_interaction():
	player_reference.can_move = false
	player_reference.can_rotate = false
	player_reference.can_interact = false
	player_reference.velocity = Vector3.ZERO
	player_reference.motion_mode = CharacterBody3D.MOTION_MODE_FLOATING
	
	get_tree().create_tween().tween_property(player_reference, "rotation_degrees", Vector3(0, 0, 0), 1)
	get_tree().create_tween().tween_property(player_reference.player_camera, "rotation_degrees", Vector3(-26, 0, 0), 1)
	await get_tree().create_tween().tween_property(player_reference, "position", Vector3(-2.67, 1.377, -12.7), 1).finished
