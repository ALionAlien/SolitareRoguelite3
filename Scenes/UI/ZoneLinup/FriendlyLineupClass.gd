@tool
extends ZoneLineup

var zone_holder_scene : PackedScene = preload("res://Scenes/UI/FriendlyZone/friendly_zone_holder.tscn")


func _on_add_stack_pressed():
	add_zone(zone_holder_scene)


func _on_add_card_pressed():
	add_random_card()


func _on_flip_bottom_row_pressed():
	flip_bottom_row()
