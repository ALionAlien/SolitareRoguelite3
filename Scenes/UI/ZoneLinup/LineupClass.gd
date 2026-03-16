@tool
class_name ZoneLineup
extends Container


var card_scene : String = "res://Card/CardScene.tscn"
var card2_scene : String = "res://Card/card1scene.tscn"
var resource_path : String = "res://Resources/CardResources/TestCard"
var resource_extention : String = ".tres"
var friendly_zone_holder_scene : PackedScene = preload("res://Scenes/UI/FriendlyZone/friendly_zone_holder.tscn")

var enemy_holders : Array[StackManagerX] = []

var last_moved_to_stack : StackZone = null
#var last_moved_from_stack : StackZone = null
var children_count : int
#
@export var seperation : float = 4.0 :
	set(value):
		seperation = value
		recalculate_seperation()
#
#func _ready():
	#recalculate_seperation()

#func _process(_delta)->void:
		#recalculate_seperation()

#func _enter_tree():
	#if not self.is_node_ready():
		#await self.ready
	#recalculate_seperation()

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
	recalculate_seperation()

func get_stacks()->Array[StackManagerX]:
	var temp_stacks : Array[StackManagerX]
	for child in get_children():
		if child is StackManagerX:
			temp_stacks.append(child)
	return temp_stacks

#func quick_mover(card : Card)->void:
	#if last_moved_to_stack and last_moved_to_stack != card.get_stack_zone():
		#var bottom_of_last_moved_stack = last_moved_to_stack.get_bottom_card()
		#if bottom_of_last_moved_stack is Card:
			#if bottom_of_last_moved_stack.is_legal_drop(card) and !bottom_of_last_moved_stack.drop_lock:
				#card.change_parent(bottom_of_last_moved_stack)
				#return
	##var filtered_stacks : Array[StackZone]
	#var bottom_card : Card = null
	#for stack in get_stacks():
		##ignore this stack if card belongs to it
		#if card.get_stack_zone() != stack.zone:
			#if stack.zone.get_bottom_card() is Card:
				#bottom_card = stack.zone.get_bottom_card()
				#if card.is_legal_drop(bottom_card):
					#card.change_parent(bottom_card)
					#last_moved_to_stack = stack.zone
					#return
			#elif !stack.zone.has_cards:
				#card.change_parent(stack.zone)
				#last_moved_to_stack = stack.zone
				#return

#func add_card()

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
	recalculate_seperation()

func flip_bottom_row()->void:
	var stacks = get_stacks()
	for stack in stacks:
		if stack.zone.get_bottom_card() is Card:
			stack.zone.get_bottom_card().flip_up()
