@tool
class_name StackManagerX
extends Control

var zone_number : int = 0

@export var default_width : float = 150:
	set(value):
		custom_minimum_size.x = value
		default_width = max(150,value)
		if get_parent() is ZoneLineup:
			get_parent().recalculate_seperation()

@export var zone : StackZone
@export var manager_y : StackManagerY
@export var default_card_gap : float = 35

var recalculated_card_gap : float

func set_zone_scale(zone_scale : float)->void:
	self.custom_minimum_size.x = default_width * zone_scale
	#pivot_offset.x=(default_card_gap/2)*zone_scale
	zone.scale = Vector2(zone_scale,zone_scale)
	if size.x != custom_minimum_size.x:
		size.x = custom_minimum_size.x
	zone.position.y = 105 * zone_scale

func get_rect2_from_collision(collision_shape_2d: CollisionShape2D) -> Rect2:
	var shape = collision_shape_2d.shape
	if shape is RectangleShape2D:
		# The size property of Rect2 is the width and height
		var shape_size = shape.size
		var half_size = size / 2.0
		# The position of Rect2 is the top-left corner
		# The global_position of the CollisionShape2D is the center
		var pos = collision_shape_2d.global_position - half_size
		return Rect2(pos, shape_size)
	else:
		# Return an empty Rect2 or handle other shapes
		return Rect2()
