extends Node
class_name GameManager

var game_stopwatch = 0

func _process(delta: float) -> void:
	game_stopwatch += delta
