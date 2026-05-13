extends Interactable
class_name Character

func _ready() -> void:
	body_mesh = $CharacterBody.mesh.surface_get_material(0)

func player_interaction():
	print("Interaction")
