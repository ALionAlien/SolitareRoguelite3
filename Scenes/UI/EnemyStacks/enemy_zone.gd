class_name EnemyZone
extends StackZone

signal damaged
signal killed

func stack_added()->void:
	damaged.emit()

func die()->void:
	killed.emit()

func lock_stack()->void:
	var all_children : Array = get_all_children(self)
	all_children.append(self)
	for node in all_children:
		if node is Card:
			node.draggable = false
			node.drop_lock = true

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


func _on_child_entered_tree(_node):
	lock_stack()
