extends Interactable
class_name KBSMike

@export var game_scene: Node3D
var talked_to = false

@onready var lookatpos = $LookAt
var interaction_active = false

func _ready() -> void:
	body_mesh = $CharacterBody.mesh.surface_get_material(0)

func player_interaction():
	if interaction_active: return
	interaction_active = true
	
	if not talked_to:
		talked_to = true
		game_scene.talked_to_char()
	
	lookatpos.look_at(player_reference.position)
	lookatpos.rotation_degrees = Vector3(0, lookatpos.rotation_degrees.y + 180, 0)
	get_tree().create_tween().tween_property(self, "rotation_degrees", lookatpos.rotation_degrees, 0.25)
	
	player_reference.show_message("Mike", "Hey. I've been tryna focus on this Godot work but this chump keeps yapping to me in my ear. Let's talk another time.", 5)
	
	await get_tree().create_timer(8).timeout
	get_tree().create_tween().tween_property(self, "rotation_degrees", Vector3(0, 173.6, 0), 0.25)
	interaction_active = false
