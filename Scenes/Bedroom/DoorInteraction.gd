extends Interactable

@export var OutfitScene: OutfitGame
@export var Overlay: ColorRect

func _ready() -> void:
	body_mesh = $Door.material
	interaction_outline = false

func player_interaction():
	if (OutfitScene.outfit_selected and OutfitScene.eyes_selected):
		player_reference.can_control = false
		player_reference.velocity = Vector3.ZERO
		print("done")
	else:
		player_reference.show_message("You", "I can't go to college dressed like this...")

func _on_body_entered(body: Node3D) -> void:
	if body is PlayerRaycast:
		interaction_outline = true
	
func _on_body_exited(body: Node3D) -> void:
	if body is PlayerRaycast:
		interaction_outline = false
