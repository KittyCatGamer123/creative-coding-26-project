extends Node3D
class_name Interactable

var body_mesh: StandardMaterial3D
@export var interaction_colour = Color("FF0")
@export var interaction_inactive_colour = Color("000")

@export var player_reference: Player

var interaction_outline: bool = false:
	set(v): 
		if v: body_mesh.stencil_color = interaction_colour
		else: body_mesh.stencil_color = interaction_inactive_colour
		interaction_outline = v
	get: return interaction_outline

func player_interaction():
	pass
