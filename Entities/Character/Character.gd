extends CharacterBody3D
class_name Character

@onready var body_mesh: StandardMaterial3D = $CharacterBody.mesh.surface_get_material(0)
@export var interaction_colour = Color("FF0")

var interaction_outline: bool = false:
	set(v): 
		if v: body_mesh.stencil_color = interaction_colour
		else: body_mesh.stencil_color = Color.BLACK
		interaction_outline = v
	get: return interaction_outline

func player_interaction():
	print("Interaction")
