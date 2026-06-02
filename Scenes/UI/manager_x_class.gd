@tool
class_name StackManagerX
extends Control

var zone_number : int = 0 :
	set(value):
		#$Panel/Label.text = str(value)
		zone_number=value

@export var action_label : Label
@export var action_count : int = 5
var action_remaining : int = 0:
	set(value):
		if action_label:
			action_label.text = str(value)
		action_remaining = value

@export var default_width : float = 150:
	set(value):
		custom_minimum_size.x = value
		default_width = max(150,value)
		if get_parent().has_method("recalculate_seperation"):
			get_parent().recalculate_seperation()

@export var zone : StackZone
#@export var custom_scale : float = 1.0
@export var default_card_gap : float = 35
@export var health : ProgressBar
var recalculated_card_gap : float

#only edit y_pos if stackzone dimensions change.
#If you need to edit the gap between stack and enemy visual-
#change the seperation constant in vbox container
var y_pos : int = 105 :
	set(value):
		if zone:
			zone.position.y = value
		y_pos = value

func _ready()->void:
	action_remaining = action_count


func set_zone_scale(zone_scale : float)->void:
	self.custom_minimum_size.x = default_width * zone_scale
	#pivot_offset.x=(default_card_gap/2)*zone_scale
	zone.scale = Vector2(zone_scale,zone_scale)
	
	#if size.x != custom_minimum_size.x:
	set_deferred("size", Vector2(custom_minimum_size.x,size.y))
	zone.position.y = y_pos * zone_scale

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

func has_card()-> bool:
	return zone.has_cards()


func process_attack()->void:
	if zone.has_cards():
		if zone.get_next_card().strikes > 0:
			zone.get_next_card().trigger_animation()
			health.value -= zone.get_next_card().base_damage
			zone.get_next_card().strikes -= 1
			print(zone.get_next_card().strikes)
		else:
			zone.get_next_card().remove()
			#pass
