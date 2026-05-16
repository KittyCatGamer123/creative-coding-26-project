extends Node3D

func _ready() -> void:
	$CanvasLayer/Overlay.visible = false

func play_pressed() -> void:
	$CanvasLayer/Play.disabled = true
	$CanvasLayer/Overlay.visible = true
	$CanvasLayer/Overlay.color = Color("0000")
	$AudioStreamPlayer.play()
	
	await get_tree().create_tween().tween_property($CanvasLayer/Overlay, "color", Color("000F"), 3).finished
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://Scenes/Bedroom/Bedroom.tscn")
