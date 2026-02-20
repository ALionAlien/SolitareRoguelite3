class_name MouseManager
extends Node2D

var is_dragging = false
var current_target : Draggable = null :
	set(target):
		if target != current_target:
			update_target(current_target, target)
		current_target = target

func _process(_delta):
	if !is_dragging:
		update_raycast()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				is_dragging = true
				if current_target and current_target.has_method("drag_entered"):
					current_target.drag_entered()
			else:
				is_dragging = false
				if current_target and current_target.has_method("drag_exited"):
					current_target.drag_exited()
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT:
			#if event.is_pressed():
				#click_position = get_global_mouse_position()
				#current_target.click_position = click_position
				#is_dragging = true
				#click_check = 1
			#if !event.is_pressed():
				#is_dragging = false
				#if current_target and current_target.has_method("drag_exited"):
					#current_target.drag_exited()

#func click_or_drag()->void:
	#if is_dragging == true:
		#print("dragging")
		#if current_target and current_target.has_method("drag_entered"):
			#current_target.drag_entered()
	#else:
		#print("clicked")

func update_raycast()->void:
	var query_2d : PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	query_2d.position = get_global_mouse_position()
	query_2d.collide_with_areas = true
	query_2d.canvas_instance_id = get_node("../CanvasLayer").get_instance_id()
	var collider_objects = get_world_2d().direct_space_state.intersect_point(query_2d)
	var colliders = collider_objects.map(
		func(dict):
			return dict.collider
	)
	
	var filtered_colliders : Array[Draggable]
	
	for collider in colliders:
		if collider is Draggable:
			filtered_colliders.append(collider)
	
	filtered_colliders.sort_custom(
		func(c1, c2):
			return c1.is_greater_than(c2)
	)
	
	if filtered_colliders and filtered_colliders.front() is Draggable:
		current_target = filtered_colliders.front()
	else:
		current_target = null
	
func update_target(old_target : Draggable = null, new_target : Draggable = null)->void:
	if old_target is Card:
		old_target.hover_exited()
	if new_target is Card and new_target.can_drag_check() and new_target.flipped_up:
		new_target.hover_entered()
