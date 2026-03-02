@tool
extends ZoneLineup

var zone_holder_scene : PackedScene = preload("res://Scenes/UI/FriendlyZone/friendly_zone_holder.tscn")


func _on_add_stack_pressed():
	add_zone(zone_holder_scene)


func _on_add_card_pressed():
	add_random_card()


func _on_flip_bottom_row_pressed():
	flip_bottom_row()

func save_data()->void:
	var current_stacks : Array[PackedScene] = []
	print(get_children())
	for node in get_children():
		if node is StackManagerX:
			var scene = PackedScene.new()
			scene.pack(node)
			current_stacks.append(scene)
	SaveManager.data.stacks = current_stacks
	print(SaveManager.data.stacks)

func load_data()->void:
	await get_tree().process_frame
	for child in get_children():
		child.queue_free()
	for scene in SaveManager.data.stacks:
		add_zone(scene)
