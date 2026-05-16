extends Interactable
class_name KBSRua

@export var game_scene: Node3D
var talked_to = false

@export var message_options: Array[String]
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
	lookatpos.rotation_degrees = Vector3(0, lookatpos.rotation_degrees.y, 0)
	get_tree().create_tween().tween_property(self, "rotation_degrees", lookatpos.rotation_degrees, 0.25)
	
	var msg: String = message_options.pick_random()
	player_reference.show_message("Rua", msg, 2)
	
	await get_tree().create_timer(3).timeout
	get_tree().create_tween().tween_property(self, "rotation_degrees", Vector3(0, 0, 0), 0.25)
	interaction_active = false
