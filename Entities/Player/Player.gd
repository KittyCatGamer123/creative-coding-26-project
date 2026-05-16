extends CharacterBody3D
class_name Player

@export_category("Controls")
@export var can_move: bool = true
@export var can_rotate: bool = true
@export var can_interact: bool = true
@export var sensitivity: float = 0.005
@export var movement_speed: float = 4.0
@export var jump_force: float = 3.5

@onready var head: Node3D = $"Head"
@onready var player_camera: Camera3D = $Head/Camera3D
@onready var interact_raycast: Area3D = $Head/Camera3D/InteractionDetection

@onready var design_outfit: MeshInstance3D = $CharacterBody/Outfit
@onready var design_eye_left: Sprite3D = $Head/EyeLeft
@onready var design_eye_right: Sprite3D = $Head/EyeRight

var message_active = false
@onready var messagebox: ColorRect = $Messages
@onready var messagebox_text: Label = $Messages/msg
@onready var messagebox_name: Label = $Messages/msg_name
@onready var messagebox_sfx: AudioStreamPlayer = $Messages/AudioStreamPlayer

func _ready():
	messagebox.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#func save_screenshot():
	#var img = get_viewport().get_texture().get_image()
	#img.save_png("")

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_WINDOW_FOCUS_IN:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if can_rotate:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * sensitivity)
			player_camera.rotate_x(-event.relative.y * sensitivity)
			player_camera.rotation.x = clamp(player_camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
	if can_interact:
		if event.is_action_pressed("Interact"):
			raycast_interact()

func _physics_process(delta: float) -> void:
	if (not is_on_floor()) and (motion_mode != MOTION_MODE_FLOATING):
		velocity += get_gravity() * delta
	
	if can_move:
		if Input.is_action_just_pressed("Jump"):
			if is_on_floor():
				velocity.y = jump_force
		
		var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
		var direction = (head.transform.basis * transform.basis * Vector3(input_dir.x, 0, input_dir.y))
		if direction:
			velocity.x = direction.x * movement_speed
			velocity.z = direction.z * movement_speed
		else:
			velocity.x = move_toward(velocity.x, 0, movement_speed)
			velocity.z = move_toward(velocity.z, 0, movement_speed)
	
	move_and_slide()

func raycast_area_entered(n: Node3D) -> void: raycast_entered(n)
func raycast_area_exited(n: Node3D) -> void: raycast_exited(n)
func raycast_body_entered(n: Node3D) -> void: raycast_entered(n)
func raycast_body_exited(n: Node3D) -> void: raycast_exited(n)

func raycast_entered(n: Node3D) -> void:
	if n is Interactable:
		n.interaction_outline = true

func raycast_exited(n: Node3D) -> void:
	if n is Interactable:
		n.interaction_outline = false

func raycast_interact():
	var interacts = interact_raycast.get_overlapping_bodies()
	interacts.append_array(interact_raycast.get_overlapping_areas())
	
	for n in interacts:
		if n is Interactable:
			n.player_interaction()

func show_message(_name: String, text: String, readtime: float = 5.0):
	if message_active: return
	
	messagebox_name.text = _name
	messagebox_text.text = text
	messagebox_text.visible_characters = 0
	messagebox.visible = true
	message_active = true
	
	while true:
		messagebox_text.visible_characters += 1
		messagebox_sfx.play()
		
		await get_tree().create_timer(0.02).timeout
		if messagebox_text.visible_ratio == 1:
			break
	
	await get_tree().create_timer(readtime).timeout
	messagebox.visible = false
	message_active = false
