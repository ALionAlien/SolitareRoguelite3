@tool
class_name StackLineup
extends HBoxContainer

var zone_holder_scene : PackedScene = preload("res://Scenes/UI/EnemyStacks/EnemyZoneHolder.tscn")

var card_scene : PackedScene = preload("res://Card/CardScene.tscn")

var enemy_holders : Array[EnemyZoneHolder] = []

var children_count : int

func _process(_delta):
	if Engine.is_editor_hint():
		if children_count != get_children().size():
			children_count = get_children().size()
			recalculate_seperation()
	else:
		if children_count != get_children().size():
			children_count = get_children().size()
			recalculate_seperation()

#when a child is added recalculate
func _enter_tree():
	recalculate_seperation()

func _exit_tree():
	recalculate_seperation()

func recalculate_seperation()->void:
	var children = get_children()
	var width : float = size.x
	print(width)
	var holders_width : float = 0
	for child in children:
		if child is EnemyZoneHolder:
			holders_width += child.size.x
	if holders_width > width:
		print("greater")



func add_stack()->void:
	var new_stack_holder := zone_holder_scene.instantiate()
	add_child(new_stack_holder)
	#await get_tree().process_frame
	#update_stacks()


func _on_add_enemy_stack_pressed():
	add_stack()
