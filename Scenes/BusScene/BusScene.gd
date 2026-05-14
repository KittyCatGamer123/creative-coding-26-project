extends Node3D

@export var player_ref: Player
@export var bus_model: CSGBox3D
@export var gametitle: Label

@export var timing_progress: TextureProgressBar
@onready var timing_pb_pos = timing_progress.position

@export var hand_ready_sprite: TextureRect
@export var hand_out_sprite: TextureRect
@export var hand_thanks_sprite: TextureRect
var bus_passed = false
var thanking = false
var game_over = false

func _ready() -> void:
	player_ref.can_move = false
	player_ref.can_rotate = false
	hand_ready_sprite.visible = true
	hand_out_sprite.visible = false
	blink_loop()
	
	get_tree().create_tween().tween_property(bus_model, "position", Vector3(-1.45, 1.8, 400), 11)
	
	await get_tree().create_timer(5).timeout
	bus_passed = true
	gametitle.text = ""
	$CanvasLayer/Control/HowTo.text = ""
	timing_progress.visible = false
	
	hand_ready_sprite.visible = true
	hand_out_sprite.visible = false
	
	await get_tree().create_timer(3).timeout
	
	gametitle.text = "THANK THE DRIVER!"
	$CanvasLayer/Control/HowTo.text = "Press E to thank the driver"
	timing_progress.value = 0
	timing_progress.max_value = 1200
	timing_progress.visible = true
	thanking = true

func _process(delta: float) -> void:
	if game_over:
		return
	
	player_ref.look_at(bus_model.position)
	
	if bus_model.position.z < -1:
		var dst = player_ref.position.distance_to(bus_model.position)
		timing_progress.value = 220 - dst
		
		var offset_range = 100.0 / dst
		var x_offset = randf_range(-offset_range, offset_range)
		var y_offset = randf_range(-offset_range, offset_range)
		timing_progress.position = timing_pb_pos + Vector2(x_offset, y_offset)
		
	elif thanking:
		if Input.is_action_pressed("Interact"):
			timing_progress.value += 0.5
			if timing_progress.value == timing_progress.max_value:
				game_over = true

func _input(event: InputEvent) -> void:
	if game_over:
		return
	
	if not bus_passed:
		if event.is_action_pressed("Interact"):
			hand_ready_sprite.visible = false
			hand_out_sprite.visible = true
		elif event.is_action_released("Interact"):
			hand_ready_sprite.visible = true
			hand_out_sprite.visible = false
	elif thanking:
		if event.is_action_pressed("Interact"):
			hand_thanks_sprite.visible = true
			hand_ready_sprite.visible = false
		elif event.is_action_released("Interact"):
			hand_thanks_sprite.visible = false
			hand_ready_sprite.visible = true

func blink_loop():
	await get_tree().create_timer(0.1).timeout
	gametitle.visible = false
	await get_tree().create_timer(0.1).timeout
	gametitle.visible = true
	blink_loop()
