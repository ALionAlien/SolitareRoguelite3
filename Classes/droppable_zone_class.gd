class_name Droppable
extends Area2D

signal hover_entered
signal hover_exited

#emit all exits purely to get rid of no-call error
func emit_all():
	hover_entered.emit()
	hover_exited.emit()

func get_bottom_card()->Card:
	for child in get_children():
		if child is Card:
			if !child.is_dragging or (child.click_check >= 1.0 and child.click_check < child.click_check_threashold):
				return child.get_bottom_card()
	return null
