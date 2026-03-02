extends Node2D


@export var friendly_lineup : ZoneLineup
@export var enemy_lineup : ZoneLineup

func _ready():
	await get_tree().process_frame
	SaveManager.load_save()


func _on_save_pressed():
	SaveManager.save_game()


func _on_load_pressed():
	SaveManager.load_save()
