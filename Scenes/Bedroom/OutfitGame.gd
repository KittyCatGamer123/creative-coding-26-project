extends Control
class_name OutfitGame

@export var player: Player
@export var editable_character_mesh: MeshInstance3D
@export var editable_character_eyeleft: Sprite3D
@export var editable_character_eyeright: Sprite3D

@export var outfits_container: ItemList
@export var eyes_container: ItemList

var outfit_selected = false
var eyes_selected = false

const OutfitList: Array[String] = [
	"res://Entities/Character/Designs/Outfits/MetropolitanJumper.jpg",
	"res://Entities/Character/Designs/Outfits/Honeysquare.jpg",
	"res://Entities/Character/Designs/Outfits/GreenJacket.jpg",
	"res://Entities/Character/Designs/Outfits/FauxHair.jpg",
	"res://Entities/Character/Designs/Outfits/EightBall.jpg",
	"res://Entities/Character/Designs/Outfits/Candycane.jpg",
	"res://Entities/Character/Designs/Outfits/BlossomTee.jpg",
	"res://Entities/Character/Designs/Outfits/StarryTop.jpg",
	"res://Entities/Character/Designs/Outfits/Dungarees.jpg",
	"res://Entities/Character/Designs/Outfits/CafeOutfit.jpg"
]

const EyesList: Array[String] = [
	"res://Entities/Character/Designs/Eyes/eye_generic.png",
	"res://Entities/Character/Designs/Eyes/eye_smallpupil.png",
	"res://Entities/Character/Designs/Eyes/eye_tense.png",
	"res://Entities/Character/Designs/Eyes/eye_sagging.png",
	"res://Entities/Character/Designs/Eyes/eye_happy.png",
	"res://Entities/Character/Designs/Eyes/eye_wince.png",
	"res://Entities/Character/Designs/Eyes/eye_eyebrows.png",
	"res://Entities/Character/Designs/Eyes/eye_nerd.png",
	"res://Entities/Character/Designs/Eyes/eye_cute.png",
	"res://Entities/Character/Designs/Eyes/eye_hearts.png",
	"res://Entities/Character/Designs/Eyes/eye_bigshiny.png",
	"res://Entities/Character/Designs/Eyes/eye_alien.png",
]

func _ready() -> void:
	for fp in OutfitList:
		outfits_container.add_icon_item(load(fp), true)
	for fp in EyesList:
		eyes_container.add_icon_item(load(fp), true)
	
	$Options/Control/Finish.disabled = true
	visible = false

func _on_outfits_item_selected(idx: int) -> void:
	editable_character_mesh.get_active_material(0).albedo_texture = load(OutfitList[idx])
	outfit_selected = true
	$Options/Control/Finish.disabled = not (outfit_selected and eyes_selected)

func _on_eyes_item_selected(idx: int) -> void:
	editable_character_eyeleft.texture = load(EyesList[idx])
	editable_character_eyeright.texture = load(EyesList[idx])
	eyes_selected = true
	$Options/Control/Finish.disabled = not (outfit_selected and eyes_selected)

func _on_finish_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	player.design_outfit.get_active_material(0).albedo_texture = editable_character_mesh.get_active_material(0).albedo_texture
	player.design_eye_left.texture = editable_character_eyeleft.texture
	player.design_eye_right.texture = editable_character_eyeright.texture
	
	player.can_move = true
	player.can_rotate = true
	visible = false
