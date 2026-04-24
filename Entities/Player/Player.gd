extends CharacterBody3D
class_name Player

@export var sensitivity: float = 0.005
@export var movement_speed: float = 4.0
@export var jump_force: float = 3.5

@onready var head: Node3D = $"Head"
@onready var player_camera: Camera3D = $Head/Camera3D
@onready var interact_raycast: Area3D = $Head/Camera3D/InteractionDetection

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	elif event.is_action_pressed("Interact"):
		raycast_interact()
	
	elif event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)
		player_camera.rotate_x(-event.relative.y * sensitivity)
		player_camera.rotation.x = clamp(player_camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
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


func raycast_entered(body: Node3D) -> void:
	if body is Character:
		body.interaction_outline = true

func raycast_exited(body: Node3D) -> void:
	if body is Character:
		body.interaction_outline = false

func raycast_interact():
	for n in interact_raycast.get_overlapping_bodies():
		if n is Character:
			n.player_interaction()
