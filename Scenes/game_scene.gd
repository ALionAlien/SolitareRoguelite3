extends Node2D

@export var friendly_lineup : ZoneLineup
@export var enemy_lineup : ZoneLineup
@export var test_label : TextEdit

func _ready()->void:
	SaveManager.load_game()

func _on_save_pressed():
	SaveManager.save_game()


func _on_modify_data_pressed():
	SaveManager.data.test = "changed data"
	print(SaveManager.data.test)


func _on_load_pressed():
	SaveManager.load_game()


func save_data()->void:
	pass
	#var current_node := get_tree().current_scene
	#for child in current_node.get_children():
		#set_owner_recursive(child, current_node)
	#var empty_pack = PackedScene.new()
	#empty_pack.pack(current_node)
	#SaveManager.data.game_screen = empty_pack

#func set_owner_recursive(node, new_owner):
	#node.owner = new_owner
	#for child in node.get_children():
		## Recursively call the function for each child
		#set_owner_recursive(child, new_owner)

func load_data()->void:
	pass
	#test_label.text = SaveManager.data.test
	#
	#for child in friendly_lineup.get_children():
		#child.queue_free()
	#for scene in SaveManager.data.stacks:
		#friendly_lineup.add_zone()
