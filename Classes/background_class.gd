@tool
class_name CardBackground
extends Panel

@export var shape : RectangleShape2D 
#:
	#set(value):
		#size = value.size
		#shape = value
