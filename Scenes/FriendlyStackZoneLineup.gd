extends StackZoneLineup

@export var card_data : Resource = preload("res://Resources/card_data.gd")

func _on_add_stack_pressed():
	add_stack()


func _on_add_card_pressed():
	add_random_card(card_data)


func _on_button_pressed():
	flip_bottom_row()
