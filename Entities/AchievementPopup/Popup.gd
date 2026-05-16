extends TextureRect
class_name AchievementPopup
signal PopupComplete

func achievement_get() -> void:
	$AudioStreamPlayer.play()
	await get_tree().create_tween().tween_property(self, "position", Vector2(711, 30), 1).finished
	await get_tree().create_tween().tween_property(self, "position", Vector2(711, 24), 0.2).finished
	await get_tree().create_timer(4).timeout
	get_tree().create_tween().tween_property(self, "position", Vector2(711, -216), 1)
	PopupComplete.emit()
