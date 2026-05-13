extends Node3D

@export var player: Player
@export var scene_animator: AnimationPlayer

@export var outfit_select_preview: Character
var outfit_init_pos: Vector3

func _ready() -> void:
	outfit_init_pos = outfit_select_preview.position
	floating_loop()
	
	player.can_control = false
	
	await get_tree().create_timer(2.5).timeout
	scene_animator.play("EyeOpening")
	await scene_animator.animation_finished
	await get_tree().create_timer(1).timeout
	scene_animator.play("GetUp")
	await scene_animator.animation_finished
	
	player.can_control = true
	await get_tree().create_timer(0.5).timeout
	player.show_message(
		"You",
		"Oh, I should leave for college soon. I better go change my outfit."
	)

func floating_loop():
	await get_tree().create_tween().tween_property(outfit_select_preview, "position", outfit_init_pos + Vector3(0, 0.1, 0), 3).set_ease(Tween.EASE_IN_OUT).finished
	await get_tree().create_tween().tween_property(outfit_select_preview, "position", outfit_init_pos, 3).set_ease(Tween.EASE_IN_OUT).finished
	floating_loop()
