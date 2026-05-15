extends Node3D

var game_active = true

@export var page_textures: Array[Texture2D]

@onready var left_hand: AnimatedSprite2D = $CanvasLayer/LeftHand
@onready var right_hand: AnimatedSprite2D = $CanvasLayer/RightHand
@export var page_texture: TextureRect
@export var page_cover: ColorRect
var right_hand_active = true

var inputs = 0
var page_idx = 0
var page_progress = 0
const next_page_threshold = 50.0

func _ready() -> void:
	page_texture.texture = page_textures[0]
	page_cover.position = Vector2(58, 18.0)
	page_cover.size = Vector2(45, 130)

func _input(event: InputEvent) -> void:
	if not game_active:
		return
	
	if event is InputEventKey:
		if event.pressed:
			if right_hand_active: right_hand.frame = 1
			else: left_hand.frame = 1
		else:
			if not right_hand_active: right_hand.frame = 0
			else: left_hand.frame = 0
			
			inputs += 1
			page_progress += 0.75
			
			page_cover.position.y = lerpf(18, 149.0, page_progress / next_page_threshold)
			page_cover.size.y = lerpf(130.0, 0, page_progress / next_page_threshold)
			
			if page_progress >= next_page_threshold:
				page_progress = 0
				page_idx += 1
				if page_idx >= len(page_textures): page_idx = 0
				page_texture.texture = page_textures[page_idx]
		
		right_hand_active = not right_hand_active
