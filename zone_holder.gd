@tool
class_name ZoneHolder
extends Control

var zone_number : int = 0

@export var default_width : float = 150:
	set(value):
		custom_minimum_size.x = value
		default_width = max(150,value)
		if get_parent() is ZoneLineup:
			get_parent().recalculate_seperation()

@export var zone : StackZone
@export var default_card_gap : float = 35

func _ready()->void:
	pass

var recalculated_card_gap : float

func _process(_delta)->void:
	if Engine.is_editor_hint():
		set_gap()
	set_gap()

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


func set_gap()->void:
	var cards : Array[Card] = zone.get_all_cards_not_dragging()
	var temp_card_gap : float = default_card_gap
	if cards.size() > 0:
		var stack_scale : float = cards[-1].global_scale.y
		var card_rect : Rect2 = get_rect2_from_collision(cards[-1].shape_owner_get_owner(0))
		var card_height : float = card_rect.size.y * stack_scale
		var height : float = size.y - card_height
		#print(height)
		var scaled_gap = default_card_gap * stack_scale
		var total_stack_height : float = (scaled_gap * cards.size())
		#print(total_stack_height+top_and_bottom_margins, " > ", height)
		if total_stack_height > height:
			var overflow_percentage : float = height/ total_stack_height
			temp_card_gap = default_card_gap * overflow_percentage
	
	#if recalculated_card_gap != temp_card_gap:
	recalculated_card_gap = temp_card_gap
	for card in cards:
		card.update_position()
