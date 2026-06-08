#@tool
class_name FriendlyZoneLineup
extends Container

var zone_holder_scene : PackedScene = preload("res://Scenes/UI/FriendlyZone/friendly_zone_holder.tscn")

var card_scene : String = "res://Card/CardScene.tscn"
var card2_scene : String = "res://Card/card1scene.tscn"
var resource_path : String = "res://Resources/CardResources/TestCard"
var resource_extention : String = ".tres"
var friendly_zone_holder_scene : PackedScene = preload("res://Scenes/UI/FriendlyZone/friendly_zone_holder.tscn")

var enemy_holders : Array[StackManagerX] = []

var last_moved_to_stack : StackZone = null

var children_count : int

func _on_add_stack_pressed():
	add_zone()


func _on_add_card_pressed():
	add_random_card()


func _on_flip_bottom_row_pressed():
	flip_bottom_row()




#
@export var seperation : float = 4.0 :
	set(value):
		seperation = value
		if Engine.is_editor_hint():
			recalculate_seperation()

func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		recalculate_seperation()
		assign_zone_numbers()


#func set_ownership(p_owner, node):    
	#for c in node.get_children():    
		#c.owner = p_owner
		#set_ownership(p_owner, c)

func save_data()->void:
	pass                
	#var current_stacks : Array[PackedScene] = []
	#for node in get_children():
		#pass
		#if node is StackManagerX:
			#var current_stack_holder : StackManagerX = node
			#set_ownership(current_stack_holder, current_stack_holder)
			#var stack_scene = PackedScene.new()
			#stack_scene.pack(current_stack_holder)
			#current_stacks.append(stack_scene)
			#
			##var current_cards_in_stack : Array[Card] = current_stack_holder.zone.get_all_cards_in_stack()
			##var stack_as_dict : Array[Dictionary]
			##for card in current_cards_in_stack:
				##if card.scene_path:
					##var dict : Dictionary = {
						##"path" = card.scene_path,
						##"flipped_up" = card.flipped_up
					##}
					##stack_as_dict.append(dict)
			##current_stacks.append(stack_as_dict)
	#SaveManager.data.friendly_stacks = current_stacks

func load_data()->void:
	pass
	#SceneSwitcher.switch_scene(SaveManager.data.game_screen)
	#for child in get_children():
		#child.queue_free()
	#for i in SaveManager.data.friendly_stacks:
		#var new_stack_holder := i.instantiate()
		#new_stack_holder.set_anchors_preset(Control.PRESET_FULL_RECT, false) 
		#new_stack_holder.call_deferred("set_anchors_preset", Control.PRESET_FULL_RECT, false)
		#add_child(new_stack_holder)
		#new_stack_holder.set_owner(get_tree().edited_scene_root)
		#for n in SaveManager.data.stacks[i]:
			##var card_scene_string : String = SaveManager.data.stacks[i][n]
			#if n is Dictionary:
				#var dict : Dictionary = n
				#new_stack_holder.zone.add_card(dict["path"], dict["flipped_up"])


func recalculate_seperation()->void:
	var new_scale : float = 1.0
	var total_holders_width : float = 0
	var children : Array = get_children()
	var vertical_gaps : int = 0
	var new_x_pos : float = 0
	for i in children.size():
		if children[i] is StackManagerX:
			total_holders_width += children[i].default_width
			if i >= 1:
				vertical_gaps += 1
	
	total_holders_width = total_holders_width + (seperation * vertical_gaps)
	
	if total_holders_width < size.x:
		var empty_space : float = size.x - total_holders_width
		new_x_pos = empty_space/2
	else:
		new_scale = size.x / total_holders_width
	
	for i in children.size():
		if children[i] is StackManagerX:
			children[i].set_zone_scale(new_scale)
	
	for i in children.size():
		if children[i] is StackManagerX:
			var child : StackManagerX = children[i]
			child.position.x = new_x_pos
			new_x_pos += child.default_width * new_scale
			#if i < children.size():
			new_x_pos += seperation * new_scale


func add_zone()->void:
	var new_stack_holder := friendly_zone_holder_scene.instantiate()
	add_child(new_stack_holder)

func get_stacks()->Array[StackManagerX]:
	var temp_stacks : Array[StackManagerX]
	for child in get_children():
		if child is StackManagerX:
			temp_stacks.append(child)
	return temp_stacks


func add_random_card()->void:
	var stacks = get_stacks()
	if stacks.size() > 0:
		var new_card : String
		if randf() < 0.5:
			new_card = card_scene
		else:
			new_card = card2_scene
		var random_zone_holder = stacks[randi() % stacks.size()]
		random_zone_holder.zone.add_card(new_card, false)
		#new_card.update_position()

func flip_bottom_row()->void:
	var stacks = get_stacks()
	for stack in stacks:
		if stack.zone.get_bottom_card() is Card:
			stack.zone.get_bottom_card().flip_up(true)

#assign a number to each x manager node based on it's position as a child
func assign_zone_numbers()->void:
	var children := get_children()
	var stacks : Array[StackManagerX]
	for i in children.size():
		if children[i] is StackManagerX:
			stacks.append(children[i])
	
	for i in stacks.size():
		stacks[i].zone_number = i
