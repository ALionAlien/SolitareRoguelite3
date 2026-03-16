extends Node

var map_screen : PackedScene
var battle_screen : PackedScene = preload("res://Scenes/GameScene.tscn")
var shop_screen : PackedScene

var current_scene = null

func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func switch_scene(scene : PackedScene):
	call_deferred("_deferred_switch_scene", scene)

func _deferred_switch_scene(scene : PackedScene):
	print(scene)
	current_scene.free()
	#print(current_scene.transform.basis)
	var new_scene : PackedScene = scene
	current_scene = new_scene.instantiate()
	#current_scene.transform.basis = current_scene.transform.orthonormalized()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
