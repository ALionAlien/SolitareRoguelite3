extends Control

var default_game_scene : PackedScene = preload("res://Scenes/GameScene.tscn")

func update_buttons()->void:
	if SaveManager.save_exists():
		$VBoxContainer/HBoxContainer/ContinueButton.disabled = false
		$VBoxContainer/HBoxContainer/DeleteSave.disabled = false
	else:
		$VBoxContainer/HBoxContainer/ContinueButton.disabled = true
		$VBoxContainer/HBoxContainer/DeleteSave.disabled = true

func _ready()->void:
	update_buttons()

func _on_newgame_pressed():
	SaveManager.new_save()
	SceneSwitcher.switch_scene(default_game_scene)

func _on_delete_save_pressed():
	SaveManager.delete_save()
	update_buttons()

func _on_continue_button_pressed():
	SaveManager.load_game()
	SceneSwitcher.switch_scene(default_game_scene)
