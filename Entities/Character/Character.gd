@tool
extends CharacterBody3D
class_name Character

@export var character_colour := Color.WHITE:
	set(val): set_mesh_col(val); character_colour = val;
	get: return character_colour

@export var outfit_texture: Texture2D:
	set(val): set_outfit_texture(val); outfit_texture = val;
	get: return outfit_texture

var character_mesh: MeshInstance3D
var outfit_mesh: MeshInstance3D

func set_mesh_col(col: Color):
	character_mesh = $CharacterBody
	var mat: StandardMaterial3D = character_mesh.mesh.surface_get_material(0)
	mat.albedo_color = col

func set_outfit_texture(texture: Texture2D):
	outfit_mesh = $CharacterBody/Outfit
	var mat: Material = outfit_mesh.get_active_material(0)
	mat.albedo_texture = texture
