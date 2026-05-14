extends Node3D

@onready var player: Player = $Player
@onready var player_raycast: CollisionShape3D = $Player/Head/Camera3D/InteractionDetection/CollisionShape3D
@onready var pointer: AnimatedSprite2D = $CanvasLayer/Hand
@onready var server: Character = $World/Character
@onready var screen_stand: CSGCylinder3D = $World/Stand
@onready var interface_howto: Control = $CanvasLayer/Control

func _ready() -> void:
	player.can_move = false
	player.can_rotate = false
	player.position = Vector3(2.8, 1.251, 6.293)
	player.rotation_degrees = Vector3(0, 0, 0)
	player_raycast.shape.length = 10
	
	pointer.position = Vector2(800.0, 704.0)
	pointer.animation = "point"
	pointer.frame = 0
	
	server.position = Vector3(0.599, 1.251, -5.8)
	server.rotation_degrees = Vector3(0, 157, 0)
	
	interface_howto.visible = false
	
	await get_tree().create_timer(1).timeout
	get_tree().create_tween().tween_property(player, "position", Vector3(2.8, 1.251, -2.625), 2)
	await get_tree().create_timer(1.5).timeout
	get_tree().create_tween().tween_property(server, "position", Vector3(2.084, 1.251, -6.628), 1)
	await get_tree().create_tween().tween_property(server, "rotation_degrees", Vector3(0, 180, 0), 1).finished
	await get_tree().create_timer(0.5).timeout
	player.show_message("Server", "Hello, what would you like?", 2)
	await get_tree().create_timer(3).timeout
	player.show_message("You", "Hey, could I get a...", 2)
	await get_tree().create_timer(2.5).timeout
	get_tree().create_tween().tween_property(pointer, "position", Vector2(800.0, 404.0), 0.5)
	player.can_rotate = true
	player.can_interact = true
	interface_howto.visible = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact"):
		pointer.play("point")
	elif event.is_action_released("Interact"):
		pointer.play_backwards("point")

func player_selected(coffee_name: String):
	interface_howto.visible = false
	player.show_message("You", coffee_name + ", please.", 1.5)
	get_tree().create_tween().tween_property(player.player_camera, "rotation", Vector3(0, 0, 0), 0.5)
	get_tree().create_tween().tween_property(player.player_camera, "rotation", Vector3(0, 0, 0), 0.5)
	get_tree().create_tween().tween_property(pointer, "position", Vector2(800.0, 704.0), 0.7)
	
	await get_tree().create_tween().tween_property(player, "rotation", Vector3(0, 0, 0), 0.6).finished
	await get_tree().create_timer(1.5).timeout
	
	get_tree().create_tween().tween_property(server, "position", Vector3(2.5, 1.251, -5.97), 0.6)
	get_tree().create_tween().tween_property(server, "rotation_degrees", Vector3(0, -140, 0), 0.6)
	
	pointer.animation = "payment_draw"
	pointer.position = Vector2(926.0, 404.0)
	pointer.play("payment_draw")
	player.show_message("Server", "Sure thing!", 1.5)
	
	await get_tree().create_timer(3).timeout
	get_tree().create_tween().tween_property(server, "rotation_degrees", Vector3(0, -180, 0), 0.3)
	get_tree().create_tween().tween_property(screen_stand, "rotation_degrees", Vector3(0, 0, 0), 0.5)
	player.show_message("Server", "That'll be €1000 please.", 1.5)
	await get_tree().create_timer(3).timeout
	player.show_message("You", "What.", 3)
