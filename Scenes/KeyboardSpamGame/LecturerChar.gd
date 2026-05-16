extends Interactable
class_name KBGameLecturer

@export var game_scene: Node3D
var talked_to = false

@onready var lookatpos = $"../LectureStand/LookatPos"
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
	lookatpos.rotation_degrees = Vector3(0, lookatpos.rotation_degrees.y + 20, 0)
	get_tree().create_tween().tween_property(self, "rotation_degrees", lookatpos.rotation_degrees, 0.25)
	
	player_reference.show_message("Lecturer", "Hey man! Are you ready to get some learning done today?", 3)
	
	await get_tree().create_timer(5).timeout
	get_tree().create_tween().tween_property(self, "rotation_degrees", Vector3(0, 166.2, 0), 0.25)
	interaction_active = false
	
