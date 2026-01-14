@tool
class_name ZoneLineup
extends Container

var zone_holder_scene : PackedScene = preload("res://Scenes/UI/FriendlyZone/friendly_zone_holder.tscn")

var card_scene : PackedScene = preload("res://Card/CardScene.tscn")

var enemy_holders : Array[ZoneHolder] = []

var children_count : int

@export var seperation : float = 4.0 :
	set(value):
		seperation = max(0,value)
		recalculate_seperation()

func _process(_delta)->void:
	if Engine.is_editor_hint():
		if children_count != get_children().size():
			children_count = get_children().size()
			recalculate_seperation()
	else:
		recalculate_seperation()

func recalculate_seperation()->void:
	var new_scale : float = 1.0
	var total_holders_width : float = 0
	var children : Array = get_children()
	var vertical_gaps : int = 0
	for i in children.size():
		if children[i] is ZoneHolder:
			total_holders_width += children[i].default_width
			if i >= 1:
				vertical_gaps += 1
	
	total_holders_width += seperation * vertical_gaps
	
	if total_holders_width > size.x:
		new_scale = size.x / total_holders_width
	
	for i in children.size():
		if children[i] is ZoneHolder:
			children[i].set_zone_scale(new_scale)
	
	var new_x_pos : float = 0
	for i in children.size():
		if children[i] is ZoneHolder:
			var child : ZoneHolder = children[i]
			child.position.x = new_x_pos
			new_x_pos += child.default_width * new_scale
			#if i < children.size():
			new_x_pos += seperation * new_scale

func add_stack()->void:
	var new_stack_holder := zone_holder_scene.instantiate()
	add_child(new_stack_holder)
	new_stack_holder.set_owner(get_tree().edited_scene_root)
