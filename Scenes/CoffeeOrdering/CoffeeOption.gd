extends Interactable

@onready var parent_scene = $"../../.."
@onready var coffee_name: String = get_node("Coffee").text

func _ready() -> void:
	body_mesh = $CSGBox3D.material
	interaction_outline = false

func player_interaction():
	player_reference.can_rotate = false
	player_reference.can_interact = false
	await get_tree().create_timer(1).timeout
	parent_scene.player_selected(coffee_name)
