@tool
extends ZoneLineup


func _on_add_stack_pressed():
	add_stack()


func _on_add_card_pressed():
	add_random_card()


func _on_flip_bottom_row_pressed():
	flip_bottom_row()
