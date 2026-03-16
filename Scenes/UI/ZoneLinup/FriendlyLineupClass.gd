@tool
extends ZoneLineup

var zone_holder_scene : PackedScene = preload("res://Scenes/UI/FriendlyZone/friendly_zone_holder.tscn")
#
#func _ready():
	#recalculate_seperation()

func _on_add_stack_pressed():
	add_zone()


func _on_add_card_pressed():
	add_random_card()


func _on_flip_bottom_row_pressed():
	flip_bottom_row()

func save_data()->void:
	#pass
	var current_stacks : Array[Array] = []
	for node in get_children():
		if node is StackManagerX:
			var current_stack_holder : StackManagerX = node
			var current_cards_in_stack : Array[Card] = current_stack_holder.zone.get_all_cards_in_stack()
			var stack_as_strings : Array[String]
			for card in current_cards_in_stack:
				if card.scene_path:
					stack_as_strings.append(card.scene_path)
			current_stacks.append(stack_as_strings)
	SaveManager.data.stacks = current_stacks

func load_data()->void:
	#SceneSwitcher.switch_scene(SaveManager.data.game_screen)
	for child in get_children():
		child.queue_free()
	for i in SaveManager.data.stacks.size():
		var new_stack_holder := friendly_zone_holder_scene.instantiate()
		add_child(new_stack_holder)
		new_stack_holder.set_owner(get_tree().edited_scene_root)
		for n in SaveManager.data.stacks[i].size():
			#var card_scene_string : String = SaveManager.data.stacks[i][n]
			#print(card_scene_string)
			new_stack_holder.zone.add_card(SaveManager.data.stacks[i][n], false)
			#print(card_string)
	await get_tree().process_frame
	recalculate_seperation()


#func add_zone()->void:
	#var new_stack_holder := friendly_zone_holder_scene.instantiate()
	#add_child(new_stack_holder)
	#new_stack_holder.set_owner(get_tree().get_first_node_in_group("screen"))
	##await get_tree().process_frame
	#recalculate_seperation()
