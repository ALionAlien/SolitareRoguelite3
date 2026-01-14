extends Node2D


@export var friendly_lineup : ZoneLineup
@export var enemy_lineup : ZoneLineup



func _on_add_stack_pressed():
	friendly_lineup.add_stack()


func _on_add_card_pressed():
	pass # Replace with function body.


func _on_add_enemy_stack_pressed():
	enemy_lineup.add_stack()
