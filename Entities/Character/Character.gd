@tool
extends CharacterBody3D

@export var character_colour := Color.WHITE:
	set(val): set_mesh_col(val); character_colour = val;
	get: return character_colour

@onready var character_mesh: MeshInstance3D = $MeshInstance3D

func set_mesh_col(col: Color):
	var mat: StandardMaterial3D = character_mesh.mesh.surface_get_material(0)
	mat.albedo_color = col
