extends Interactable
class_name WardrobeInteraction

@export var wardrobe_game: OutfitGame

func _ready() -> void:
	body_mesh = $Mesh.material

func player_interaction():
	player_reference.can_move = false
	player_reference.can_rotate = false
	player_reference.velocity = Vector3(0,0,0)
	wardrobe_game.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_body_entered(body: Node3D) -> void:
	if body is PlayerRaycast:
		interaction_outline = true
	
func _on_body_exited(body: Node3D) -> void:
	if body is PlayerRaycast:
		interaction_outline = false
