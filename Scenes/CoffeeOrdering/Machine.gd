extends Interactable

@onready var parent_scene = $"../.."

func _ready() -> void:
	body_mesh = $Machine.material
	interaction_outline = false

func player_interaction():
	parent_scene.point_at_machine()
