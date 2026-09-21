extends Node2D

var elapsed_time: float = 0.0

func _process(delta: float) -> void:
	elapsed_time += delta
