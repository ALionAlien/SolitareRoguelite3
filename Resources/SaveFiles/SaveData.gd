class_name SaveData
extends Resource

@export var test : String = "default"

@export var friendly_stacks : Array[Array]
#@export var friendly_lineup : PackedScene
@export var game_screen : PackedScene = preload("res://Scenes/GameScene.tscn")
@export var game_ui : PackedScene
