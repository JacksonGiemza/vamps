extends Node2D
#
#@export var grid_size := 64
#@export var world_size := 4000
#
#func _draw():
	## background
	#draw_rect(
		#Rect2(-world_size, -world_size, world_size * 2, world_size * 2),
		#Color("#27382b")
	#)
#
	## grid
	#for x in range(-world_size, world_size, grid_size):
		#draw_line(
			#Vector2(x, -world_size),
			#Vector2(x, world_size),
			#Color("#334a38"),
			#2
		#)
#
	#for y in range(-world_size, world_size, grid_size):
		#draw_line(
			#Vector2(-world_size, y),
			#Vector2(world_size, y),
			#Color("#334a38"),
			#2
		#)
