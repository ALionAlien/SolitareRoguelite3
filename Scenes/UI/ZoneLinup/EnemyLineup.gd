@tool
class_name EnemyZoneLineup
extends Container

var enemy_holder_scene : PackedScene = preload("res://Scenes/UI/EnemyStacks/enemy_zone_holder.tscn")

@export var seperation : float = 4.0 :
	set(value):
		seperation = value
		recalculate_seperation()

func _on_add_enemy_stack_pressed():
	add_zone()

func add_zone()->void:
	var new_stack_holder := enemy_holder_scene.instantiate()
	add_child(new_stack_holder)
	recalculate_seperation()

func recalculate_seperation()->void:
	var new_scale : float = 1.0
	var total_holders_width : float = 0
	var children : Array = get_children()
	var vertical_gaps : int = 0
	var new_x_pos : float = 0
	for i in children.size():
		if children[i] is StackManagerX:
			total_holders_width += children[i].default_width
			if i >= 1:
				vertical_gaps += 1
	
	total_holders_width = total_holders_width + (seperation * vertical_gaps)
	
	if total_holders_width < size.x:
		var empty_space : float = size.x - total_holders_width
		new_x_pos = empty_space/2
	else:
		new_scale = size.x / total_holders_width
	
	for i in children.size():
		if children[i] is StackManagerX:
			children[i].set_zone_scale(new_scale)
	
	for i in children.size():
		if children[i] is StackManagerX:
			var child : StackManagerX = children[i]
			child.position.x = new_x_pos
			new_x_pos += child.default_width * new_scale
			#if i < children.size():
			new_x_pos += seperation * new_scale
	assign_zone_numbers()

func get_stacks()->Array[StackManagerX]:
	var temp_stacks : Array[StackManagerX]
	for child in get_children():
		if child is StackManagerX:
			temp_stacks.append(child)
	return temp_stacks

#assign a number to each x manager node based on it's position as a child
func assign_zone_numbers()->void:
	var children := get_children()
	var stacks : Array[StackManagerX]
	for i in children.size():
		if children[i] is StackManagerX:
			stacks.append(children[i])
	
	for i in stacks.size():
		stacks[i].zone_number = i
