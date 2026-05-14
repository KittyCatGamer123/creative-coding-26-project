extends Node3D

var note_taking_active = false

## Slide Stuff
var slide_data = []
@onready var slide_title: Node3D = $World/Presenation/TitlePiece
@onready var slide_desc: Node3D = $World/Presenation/Description
@onready var slide_bulletp: Node3D = $World/Presenation/Bulletpoint
@onready var slide_obj_order = [slide_title, slide_desc, slide_bulletp]

## References
@export_category("References")
@onready var hand_pen: TextureRect = $CanvasLayer/Interface/HandPen
@onready var hand_paper: TextureRect = $CanvasLayer/Interface/HandPaper
@export var lines: Line2D
@export var player: Player
@export var player_crosshair: Label
var current_line: Line2D = null
var mouse_down = false
var offset := Vector2(2, 3)

@onready var presentation_csg: CSGBox3D = $World/Presenation
@onready var presentation_light: OmniLight3D = $World/Presenation/OmniLight3D
@onready var presentation_sfx: AudioStreamPlayer3D = $World/Presenation/AudioStreamPlayer3D

@onready var lecturer_char: Character = $World/Character

func _ready() -> void:
	slide_data = JSON.parse_string(FileAccess.open("res://Scenes/NoteTaking/Presenation/presentation_data.json", FileAccess.ModeFlags.READ).get_as_text())
	
	player_crosshair.visible = true
	hand_paper.position = Vector2(192.0, 662.0) #294.0
	hand_pen.position = Vector2(498.0, 697.0)
	lecturer_char.position = Vector3(5, 2.054, -13.7)
	lecturer_char.rotation_degrees = Vector3(0, 162.1, 0)
	
	player.show_message(
		"Lecturer", 
		"Alright everyone, welcome back to Game Studies. Today we'll be covering an important topic.",
		2.5
	)
	await get_tree().create_timer(5).timeout
	player.show_message(
		"Lecturer", 
		"With that, I recommend you all take out notebooks and take notes for this.",
		2.5
	)
	await get_tree().create_timer(4.5).timeout
	
	player_crosshair.visible = false
	get_tree().create_tween().tween_property(hand_paper, "position", Vector2(212.0, 294.0), 0.5)
	await get_tree().create_tween().tween_property(hand_pen, "position", Vector2(488.0, 353.0), 0.5).finished
	await get_tree().create_timer(1).timeout
	
	$CanvasLayer/Title.visible = true
	$CanvasLayer/HowTo.visible = true
	note_taking_active = true
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	
	await get_tree().create_timer(1).timeout
	presentation_loop()

func _input(event: InputEvent) -> void:
	if not note_taking_active:
		return
	
	if event is InputEventMouseMotion:
		hand_pen.position = event.position
		hand_pen.position.x = clamp(hand_pen.position.x, 333.0, 518.0)
		hand_pen.position.y = clamp(hand_pen.position.y, 301.0, 593.0)
		
		if mouse_down:
			current_line.add_point(hand_pen.position + offset)
	
	elif event is InputEventMouseButton:
		if event.button_index != MOUSE_BUTTON_LEFT:
			return
		
		mouse_down = event.pressed
		if mouse_down:
			current_line = Line2D.new()
			current_line.default_color = Color("001626ff")
			current_line.width = 1.5
			lines.add_child(current_line)
			current_line.add_point(hand_pen.position + offset)

var slide_time: float = 5.0
var slide_idx = 1

func presentation_loop():
	presentation_csg.material.emission = Color("000000")
	presentation_light.visible = false
	presentation_sfx.play()
	
	if slide_idx < len(slide_data):
		var current_slide_data = slide_data[slide_idx]
		var slide_type = current_slide_data["type"]
		for n in range(0, len(slide_obj_order)):
			slide_obj_order[n].visible = (n == slide_type)
		
		var slide_obj_children = slide_obj_order[slide_type].get_children()
		for node_idx in range(0, len(current_slide_data["text"])):
			slide_obj_children[node_idx].text = current_slide_data["text"][node_idx]
	
	await get_tree().create_timer(0.1).timeout
	
	presentation_csg.material.emission = Color("e6e6e6")
	presentation_light.visible = true
	
	await get_tree().create_timer(slide_time).timeout
	slide_time /= 1.25
	slide_idx += 1
	if slide_time > 0.009:
		print(slide_idx, ":  ", slide_time)
		presentation_loop()
	else:
		presentation_end()

func presentation_end():
	await get_tree().create_timer(2).timeout
	
	note_taking_active = false
	hand_pen.visible = false
	hand_paper.visible = false
	$CanvasLayer/Title.visible = false
	$CanvasLayer/HowTo.visible = false
	$CanvasLayer/Interface/Line2D.visible = false
	
	await get_tree().create_timer(3).timeout
	
	player.show_message(
		"Lecturer", 
		"Thank you for coming to today's class. Hopefully you got all that. Feel free to stay longer if you need to perfect your notes.",
		3
	)
	
	await get_tree().create_timer(7).timeout
	await get_tree().create_tween().tween_property(lecturer_char, "rotation_degrees", Vector3(0, 300, 0), 0.6).finished
	await get_tree().create_tween().tween_property(lecturer_char, "position", Vector3(5.8, 0.764, -15.4), 0.6).finished
	get_tree().create_tween().tween_property(lecturer_char, "rotation_degrees", Vector3(0, 270, 0), 0.3)
	get_tree().create_tween().tween_property(lecturer_char, "position", Vector3(27.21, 0.764, -15.4), 2)
	
	await get_tree().create_timer(1).timeout
	note_taking_active = true
	hand_pen.visible = true
	hand_paper.visible = true
	$CanvasLayer/HowTo.text = "Press E to stop taking notes."
	$CanvasLayer/HowTo.visible = true
	$CanvasLayer/Interface/Line2D.visible = true
