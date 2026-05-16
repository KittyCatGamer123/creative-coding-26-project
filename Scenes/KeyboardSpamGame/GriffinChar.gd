extends Interactable
class_name KBSPeter

@export var game_scene: Node3D
var talked_to = false

@onready var lookatpos = $LookAt
var interaction_active = false

@onready var shrug_left = $"../../CanvasLayer/ShrugLeft"
@onready var shrug_right = $"../../CanvasLayer/ShrugRight"


func _ready() -> void:
	body_mesh = $CharacterBody.mesh.surface_get_material(0)
	shrug_left.visible = false
	shrug_right.visible = false

func player_interaction():
	if interaction_active: return
	interaction_active = true
	
	if not talked_to:
		talked_to = true
		game_scene.talked_to_char()
	
	lookatpos.look_at(player_reference.position)
	lookatpos.rotation_degrees = Vector3(0, lookatpos.rotation_degrees.y + 180, 0)
	get_tree().create_tween().tween_property(self, "rotation_degrees", lookatpos.rotation_degrees, 0.25)
	
	player_reference.can_move = false
	player_reference.can_interact = false
	player_reference.show_message("Griffin", "Sup. Any idea how I could export a Mac build without needing a Mac in Godot? Is that possible?", 3)
	
	await get_tree().create_timer(5).timeout
	shrug_left.visible = true
	shrug_right.visible = true
	shrug_left.play("shrug")
	shrug_right.play("shrug")
	
	await get_tree().create_timer(1.5).timeout
	shrug_left.play_backwards("shrug")
	shrug_right.play_backwards("shrug")
	
	await get_tree().create_timer(1.5).timeout
	shrug_left.visible = false
	shrug_right.visible = false
	player_reference.show_message("Griffin", "Alright then. I'll try figure it out, it's probably fine.", 3)
	
	await get_tree().create_timer(4).timeout
	get_tree().create_tween().tween_property(self, "rotation_degrees", Vector3(0, 173.6, 0), 0.25)
	interaction_active = false
	player_reference.can_move = true
	player_reference.can_interact = true
