@tool
class_name ZoneLineup
extends Container


var card_scene : PackedScene = preload("res://Card/CardScene.tscn")
var card2_scene : PackedScene = preload("res://Card/card_1_scene.tscn")
var resource_path : String = "res://Resources/CardResources/TestCard"
var resource_extention : String = ".tres"

var enemy_holders : Array[StackManagerX] = []
var stacks : Array[StackManagerX] = []
var last_moved_to_stack : StackZone = null
#var last_moved_from_stack : StackZone = null
var children_count : int

@export var seperation : float = 4.0 :
	set(value):
		seperation = max(0,value)
		recalculate_seperation()

func _ready():
	update_stacks()

func _process(_delta)->void:
		recalculate_seperation()

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
	
	total_holders_width += seperation * vertical_gaps
	
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

func add_zone(scene : PackedScene)->void:
	var new_stack_holder := scene.instantiate()
	add_child(new_stack_holder)
	new_stack_holder.set_owner(get_tree().edited_scene_root)
	update_stacks()

func update_stacks()->void:
	var temp_stacks : Array[StackManagerX]
	for child in get_children():
		if child is StackManagerX:
			temp_stacks.append(child)
	stacks = temp_stacks
	print(stacks)

func quick_mover(card : Card)->void:
	if last_moved_to_stack and last_moved_to_stack != card.get_stack_zone():
		var bottom_of_last_moved_stack = last_moved_to_stack.get_bottom_card()
		if bottom_of_last_moved_stack is Card:
			if bottom_of_last_moved_stack.is_legal_drop(card) and !bottom_of_last_moved_stack.drop_lock:
				card.change_parent(bottom_of_last_moved_stack)
				return
	#var filtered_stacks : Array[StackZone]
	var bottom_card : Card = null
	for stack in stacks:
		#ignore this stack if card belongs to it
		if card.get_stack_zone() != stack.zone:
			if stack.zone.get_bottom_card() is Card:
				bottom_card = stack.zone.get_bottom_card()
				if card.is_legal_drop(bottom_card):
					card.change_parent(bottom_card)
					last_moved_to_stack = stack.zone
					return
			elif !stack.zone.has_cards:
				card.change_parent(stack.zone)
				last_moved_to_stack = stack.zone
				return

func add_random_card()->void:
	if stacks:
		var new_card
		if randf() < 0.5:
			new_card = card_scene.instantiate()
		else:
			new_card = card2_scene.instantiate()
		new_card.connect("quick_move",quick_mover)
		new_card.connect("update_last_moved_stack",set_last_moved_stack)
		new_card.mana_cost = randi_range(0,4)
		var random_zone_holder = stacks[randi() % stacks.size()]
		if random_zone_holder.zone.get_bottom_card():
			add_child(new_card)
			new_card.change_parent(random_zone_holder.zone.get_bottom_card())
		elif random_zone_holder.zone is StackZone:
			#random_zone_holder.zone.add_child(new_card)
			add_child(new_card)
			new_card.change_parent(random_zone_holder.zone)
		new_card.update_position()
	
	await get_tree().process_frame
	update_stacks()

#func random_card_data()->CardData:
	##set back to 1 - 21
	#var random_numer : int = randi_range(1,21)
	#var path : String = resource_path + str(random_numer) + resource_extention
	#var card_data : CardData = load(path)
	#return card_data

func set_last_moved_stack(stack : StackZone)->void:
	last_moved_to_stack = stack

func flip_bottom_row()->void:
	update_stacks()
	for stack in stacks:
		if stack.zone.get_bottom_card() is Card:
			stack.zone.get_bottom_card().flip_up()
