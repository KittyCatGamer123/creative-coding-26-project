extends Node3D

var game_active = false
var game_finished = false
var can_leave = false

@export var page_textures: Array[Texture2D]

@onready var left_hand: AnimatedSprite2D = $CanvasLayer/LeftHand
@onready var right_hand: AnimatedSprite2D = $CanvasLayer/RightHand
@export var page_texture: TextureRect
@export var page_cover: ColorRect
var right_hand_active = true

@onready var player_reference: Player = $Player
@onready var player_raycast: CollisionShape3D = $Player/Head/Camera3D/InteractionDetection/CollisionShape3D

@onready var game_title: Label = $CanvasLayer/Title
@onready var game_howto: Label = $CanvasLayer/HowTo
@onready var game_progressbar: TextureProgressBar = $CanvasLayer/TimingProgress
@onready var game_progressbar_start_pos = game_progressbar.position
@onready var game_timeleft: Label = $CanvasLayer/TimeLeft
@onready var game_timer: Timer = $CanvasLayer/SpamTimer
@onready var game_countdown: Label = $CanvasLayer/Countdown
@onready var game_gj: Label = $CanvasLayer/GoodJob
@onready var game_score_lbl: Label = $CanvasLayer/Score
@onready var game_howto_2: Label = $CanvasLayer/HowTo2

@onready var achievement_cps: AchievementPopup = $CanvasLayer/Popup
@onready var achievement_social: AchievementPopup = $CanvasLayer/Popup2

var inputs = 0
var page_idx = 0
var page_progress = 0
var pages_finished = 0
const next_page_threshold = 50.0

func _ready() -> void:
	player_raycast.shape.length = 1.2
	page_texture.texture = page_textures[0]
	page_cover.position = Vector2(58, 18.0)
	page_cover.size = Vector2(45, 130)
	
	left_hand.visible = false
	right_hand.visible = false
	game_title.visible = false
	game_howto.visible = false
	game_progressbar.visible = false
	game_timeleft.visible = false
	game_countdown.visible = false
	game_gj.visible = false
	game_score_lbl.visible = false
	game_howto_2.visible = false
	
	enter_transition()

func _input(event: InputEvent) -> void:
	if game_finished and event.is_action_pressed("Interact"):
		game_finished = false
		can_leave = true
		await get_tree().create_tween().tween_property(player_reference, "position", Vector3(-2.67, 1.377, -10.5), 0.25).finished
		player_reference.can_move = true
		player_reference.can_rotate = true
		player_reference.can_interact = true
		player_reference.motion_mode = CharacterBody3D.MOTION_MODE_GROUNDED
		
		left_hand.visible = false
		right_hand.visible = false
		game_gj.visible = false
		game_score_lbl.visible = false
		game_howto_2.visible = false
		return
	
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
				pages_finished += 1
				
				if page_idx >= len(page_textures): page_idx = 0
				page_texture.texture = page_textures[page_idx]
		
		right_hand_active = not right_hand_active

func _process(delta: float) -> void:
	if game_active:
		var offset_range = 15 / game_timer.time_left
		var x_offset = randf_range(-offset_range, offset_range)
		var y_offset = randf_range(-offset_range, offset_range)
		
		game_progressbar.value = game_timer.time_left
		game_timeleft.text = "%.1fs" % game_timer.time_left
		game_progressbar.position = game_progressbar_start_pos + Vector2(x_offset, y_offset)

func start_game():
	var start_pos_left = left_hand.position
	var start_pos_right = right_hand.position
	
	left_hand.position += Vector2(-200, 450)
	right_hand.position += Vector2(200, 450)
	left_hand.visible = true
	right_hand.visible = true
	
	get_tree().create_tween().tween_property(left_hand, "position", start_pos_left, 0.6)
	await get_tree().create_tween().tween_property(right_hand, "position", start_pos_right, 0.6).finished
	
	game_progressbar.value = game_progressbar.max_value
	game_timeleft.text = "15.0s"
	
	game_title.visible = true
	game_howto.visible = true
	game_progressbar.visible = true
	game_timeleft.visible = true
	
	await get_tree().create_timer(3).timeout
	
	game_title.visible = false
	game_howto.visible = false
	game_countdown.visible = true
	
	for n in range(3, 0, -1):
		game_countdown.text = str(n)
		await get_tree().create_timer(1).timeout
	
	game_countdown.visible = false
	game_timer.start()
	game_active = true

func on_spam_timer_timeout() -> void:
	game_active = false
	game_progressbar.position = game_progressbar_start_pos
	
	await get_tree().create_timer(2.5).timeout
	
	game_progressbar.visible = false
	game_timeleft.visible = false
	
	game_gj.visible = true
	game_score_lbl.text = "Score: " + str(inputs * 5) + "\n(" + str(pages_finished) + " pages)"
	game_score_lbl.visible = true
	game_howto_2.visible = true
	
	if pages_finished >= 9:
		achievement_cps.achievement_get()
	else:
		game_finished = true

var chars_talked_to = 0

func talked_to_char():
	chars_talked_to += 1
	
	if chars_talked_to == 4:
		game_finished = false
		achievement_social.achievement_get()

func ach_popup_complete() -> void: game_finished = true
func ach2_popup_complete() -> void: game_finished = true

func enter_transition():
	var trans_img = $CanvasLayer/TransitionTexture
	var mat = trans_img.material
	mat.set_shader_parameter("NumDivisions", 1)
	trans_img.visible = true
	await get_tree().create_tween().tween_property(mat, "shader_parameter/NumDivisions", 200, 1.0).finished
	trans_img.visible = false
