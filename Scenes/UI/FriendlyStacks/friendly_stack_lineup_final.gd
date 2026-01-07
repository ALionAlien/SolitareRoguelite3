@tool
class_name EnemyStackLineup
extends HBoxContainer


var zone_holder_scene : PackedScene = preload("res://Scenes/UI/FriendlyStacks/friendly_zone_holder.tscn")

var card_scene : PackedScene = preload("res://Card/CardScene.tscn")

var resource_path : String = "res://Resources/CardResources/TestCard"
var resource_extention : String = ".tres"

var stacks : Array[ZoneHolder] = []
var last_moved_stack : StackZone = null

@export var default_seperation : float = 170 :
	set(value):
		default_seperation = value
		recalculate_seperation()

var children_count : int

func _process(_delta):
	if Engine.is_editor_hint():
		if children_count != get_children().size():
			children_count = get_children().size()
			recalculate_seperation()
	else:
		if children_count != get_children().size():
			children_count = get_children().size()
			recalculate_seperation()

#when a child is added recalculate
func _enter_tree():
	recalculate_seperation()

func _exit_tree():
	recalculate_seperation()

func recalculate_seperation()->void:
	var temp_seperation : float = default_seperation
	var stacks_scale : float = 1
	var width : float = get_size().x
	var children : Array = get_children()
	var total_seperation = max(children.size(),1) * temp_seperation
	if total_seperation > width:
		temp_seperation = width / children.size()
		stacks_scale = width / total_seperation
	add_theme_constant_override("separation", floor(temp_seperation))
	for child in get_children():
		if child is ZoneHolder:
			#child.set_margin(recalculated_margin)
			child.set_zone_scale(stacks_scale)

func update_stacks()->void:
	var temp_stacks : Array[ZoneHolder]
	for child in get_children():
		if child is ZoneHolder:
			temp_stacks.append(child)
	stacks = temp_stacks

func _on_add_stack_pressed():
	add_stack()

func add_stack()->void:
	var new_stack_holder := zone_holder_scene.instantiate()
	add_child(new_stack_holder)
	#await get_tree().process_frame
	update_stacks()

func _on_add_card_pressed():
	add_random_card(random_card_data())

func quick_mover(card : Card)->void:
	if last_moved_stack and last_moved_stack != card.get_stack_zone():
		var bottom_of_last_moved_stack = last_moved_stack.get_bottom_card()
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
					last_moved_stack = stack.zone
					return
			elif stack.zone.is_empty:
				card.change_parent(stack.zone)
				last_moved_stack = stack.zone
				return

func add_random_card(_card : Resource)->void:
	if stacks:
		var new_card = card_scene.instantiate()
		new_card.connect("quick_move",quick_mover)
		new_card.connect("update_last_moved_stack",set_last_moved_stack)
		new_card.card_data = random_card_data()
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

func random_card_data()->CardData:
	#set back to 1 - 21
	var random_numer : int = randi_range(1,1)
	var path : String = resource_path + str(random_numer) + resource_extention
	var card_data : CardData = load(path)
	return card_data

func set_last_moved_stack(stack : StackZone)->void:
	last_moved_stack = stack


func _on_button_pressed():
	flip_bottom_row()

func flip_bottom_row()->void:
	for stack in stacks:
		if stack.zone.get_bottom_card():
			stack.zone.get_bottom_card().flip_up()
