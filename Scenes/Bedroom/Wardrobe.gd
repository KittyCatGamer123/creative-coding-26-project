extends CSGBox3D
class_name WardrobeInteraction

@onready var body_mesh: StandardMaterial3D = material
@export var interaction_colour = Color("FF0")

@export var plr: Player
@export var wardrobe_game: OutfitGame

var interaction_outline: bool = false:
	set(v): 
		if v: body_mesh.stencil_color = interaction_colour
		else: body_mesh.stencil_color = Color("00000000")
		interaction_outline = v
	get: return interaction_outline

func player_interaction():
	plr.can_control = false
	wardrobe_game.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
