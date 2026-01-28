class_name Draggable
extends Area2D
#testing git upload
var draggable : bool = true
var is_hovering : bool = false
var is_dragging : bool = false
var return_position : Vector2 = Vector2.ZERO
var return_speed : float = 0.25
var drop_ignore_list : Array[Droppable]
var hover_target : Droppable = null : 
	set(value):
		if hover_target != value:
			update_hover_targets(hover_target, value)
			hover_target = value
var click_check : float = 0
var click_check_threashold : float = 1.16
var click_position : Vector2 = Vector2.ZERO

func _ready():
	update_data()

func _process(delta)->void:
	#add delta to click check
	if click_check >= 1.0 and click_check <= click_check_threashold:
		click_check += delta
	#update position if dragging
	if is_dragging:
		hover_check()
		global_position = lerp(global_position,get_global_mouse_position() - (click_position * global_scale), 0.98)
	else:
		position = lerp(position, return_position, return_speed)

func clicked()->void:
	pass

func drag_exited()->void:
	#check if click check has expired before running drop check
	if click_check >= 1.0 and click_check < click_check_threashold:
		#print("clicked")
		clicked()
	else:
		drop_check()
	#reset hover target and other data
	if hover_target != null:
		hover_target = null
	
	if get_parent():
		global_scale = get_parent().global_scale
	is_dragging = false
	update_data()

func hover_entered()->void:
	is_hovering = true
	update_data()

func hover_exited()->void:
	is_hovering = false
	update_data()

#class will be overwritten in subclasses to add checks before dragging
func can_drag_check()->bool:
	return draggable

#drop check is used by inherited scripts to check if the hovering target is a legal drop target
func drop_check()->void:
	return

#hover check is called every frame by the process function IF card is being dragged
#hover check finds and sorts overlaping areas then updates the current hover target
func hover_check()->void:
	var nodes : Array = get_overlapping_areas()
	var areas_sorted : Array[Dictionary]
	var self_rect : Rect2 = get_rect2_from_collision(self.shape_owner_get_owner(0))
	if nodes:
		#create an array of dictionaries storing the area of each overlaping node
		for node in nodes:
			if node is Droppable and !drop_ignore_list.has(node):
				var current_rect : Rect2 = get_rect2_from_collision(node.shape_owner_get_owner(0))
				var overlap = get_overlap_area(self_rect, current_rect)
				areas_sorted.append({"node":node,"overlap":overlap, "width":(current_rect.get_area()*node.global_scale).x})
	
	#sort by area
	if areas_sorted.size() > 0:
		#store largest area
		areas_sorted.sort_custom(sort_by_width)
		var largest_width : float = areas_sorted[-1]["width"]
		#remove all with smaller width
		for object in areas_sorted:
			if object["width"] < (largest_width-100): #100 is for some margin of error with equal size boxes
				areas_sorted.erase(object)
		#sort remaining by overlap size
		areas_sorted.sort_custom(sort_by_overlap)
		#update hover target
		if hover_target != areas_sorted[-1]["node"]:
			hover_target = areas_sorted[-1]["node"]
	elif hover_target != null:
		hover_target = null
	#print(hover_target)
	return

#sort by area
func sort_by_width(a, b)->bool:
	if a["width"] < b["width"]:
		return true
	return false

#sort by overlap
func sort_by_overlap(a, b)->bool:
	if a["overlap"] < b["overlap"]:
		return true
	return false

func update_data()->void:
	pass

func get_rect2_from_collision(collision_shape_2d: CollisionShape2D) -> Rect2:
	var shape = collision_shape_2d.shape
	if shape is RectangleShape2D:
		# The size property of Rect2 is the width and height
		var size = shape.size
		var half_size = size / 2.0
		# The position of Rect2 is the top-left corner
		# The global_position of the CollisionShape2D is the center
		var pos = collision_shape_2d.global_position - half_size
		return Rect2(pos, size)
	else:
		# Return an empty Rect2 or handle other shapes
		return Rect2()

#takes two rect2's and returns the overlapping area as a float
func get_overlap_area(rect1: Rect2, rect2: Rect2) -> float:
	# Get the intersection rectangle
	var intersection : Rect2 = rect1.intersection(rect2)
	
	# If the intersection is empty (area is 0), they don't overlap or only touch at edges/corners
	if intersection.get_area() > 0:
		return intersection.get_area() # Returns the area of the overlapping region
	else:
		return 0.0 # No overlap

func update_ignore_list()->void:
	pass

#function connected to the set/get of 'current_target' variable
func update_hover_targets(old_target : Droppable, new_target : Droppable)->void:
	if old_target is Droppable and old_target.has_signal("hover_exited"):
		old_target.hover_exited.emit()
	if new_target is Droppable and new_target.has_signal("hover_entered"):
		new_target.hover_entered.emit()
		#update the scale of dragging card when hover target changes
		if new_target.get_parent() is Card:
			global_scale = new_target.get_parent().global_scale
		elif new_target is StackZone:
			global_scale = new_target.global_scale

#creates an array of all nested children
func get_all_children(node)->Array:
	var children_list : Array = []
	for child in node.get_children():
		if child.get_child_count() > 0:
			children_list.append(child)
			children_list.append_array(get_all_children(child))
		else:
			children_list.append(child)
	return children_list

#finds the first child of a certain type
func find_first_node_of_type(parent_node: Node, target_type: String) -> Node:
	for child in parent_node.get_children():
		if child.is_class(target_type):
			return child
		var found_node = find_first_node_of_type(child, target_type)
		if found_node:
			return found_node
	return null
