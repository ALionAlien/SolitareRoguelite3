class_name Card
extends Draggable

signal quick_move(card : Card)
signal update_last_moved_stack(stack : StackZone)


var mana_cost : int = 0

#@export var card_data : CardData = preload("res://Resources/CardResources/TestCard1.tres")
#
#var colors_array : Array[String] :
	#set(value):
		#colors_array = value
	#get():
		#if card_data == null:
			#return colors_array
		#var temp_colour_array : Array[String]
		#if card_data.blue: temp_colour_array.append("blue")
		#if card_data.red: temp_colour_array.append("red")
		#if card_data.orange: temp_colour_array.append("orange")
		#if card_data.purple: temp_colour_array.append("purple")
		#if card_data.green: temp_colour_array.append("green")
		#if card_data.white: temp_colour_array.append("white")
		#if card_data.black: temp_colour_array.append("black")
		#return temp_colour_array

@export var base_damage : int = 0:
	set(value):
		calculate_total_damage()
		total_damage = value
var damage_buff_temp : int = 0:
	set(value):
		calculate_total_damage()
		total_damage = value
var damage_stack_buff : int = 0:
	set(value):
		calculate_total_damage()
		total_damage = value
var damage_multiplier_temp : int = 0:
	set(value):
		calculate_total_damage()
		total_damage = value
var damage_multiplier_stack_buff: int = 0:
	set(value):
		calculate_total_damage()
		total_damage = value

var total_damage : int = 0

var current_card_stack : StackZone = null
var total_stack_mana : int = 0 :
	set(value):
		#update the visual if the cost is set to something different
		if total_stack_mana != value:
			total_stack_mana = value
			update_data()
var max_stack_cost : int = 10

func calculate_total_damage()->int:
	var damage : int = base_damage
	return damage

var flipped_up : bool = false 
#set(value)

var drop_lock : bool = false :
	set(value):
		drop_lock = value
		update_data()
var is_in_stack : bool = false :
	set(value):
		is_in_stack = value
		update_data()

var card_gap : float = 0

func _ready():
	super._ready()
	update_position()
	update_data()
	if self == get_bottom_card():
		#check_stack_upwards()
		calculate_total_mana()

func _process(delta):
	super._process(delta)
	if is_dragging:
		get_bottom_card().calculate_total_mana()

func drop_check():
	#early return if not hovering over anything
	if !hover_target:
		return
	#get the most-child card
	#get the parent because hover target is a hitbox, which is a child of card
	if hover_target:
		var target_parent = hover_target.get_parent()
		#var card_target : Card = hover_target.get_parent()
		if hover_target is StackZone and hover_target.is_empty:
			change_parent(hover_target)
		if target_parent is Card:
			var bottom_of_stack : Card = target_parent.get_bottom_card()
			if is_legal_drop(bottom_of_stack):
				change_parent(bottom_of_stack)
		if hover_target is StackZone and hover_target.get_bottom_card():
			var bottom_of_stack : Card = hover_target.get_bottom_card()
			if is_legal_drop(bottom_of_stack):
				change_parent(bottom_of_stack)
	update_position()

func hover_entered()->void:
	super.hover_entered()

func drag_entered():
	if can_drag_check() and flipped_up:
		click_position = get_local_mouse_position() * get_parent().global_scale
		#print(get_parent().scale)
		update_ignore_list()
		set_children_z_index(100)
		click_check = 1.0
		z_index = 1
		is_dragging = true
		get_manager_y().set_gap()


func drag_exited():
	super.drag_exited()
	#check_stack_upwards()
	#get_bottom_card().calculate_total_mana()
	set_children_z_index(0)
	get_manager_y().set_gap()
	get_bottom_card().calculate_total_mana()


func flip_down():
	pass

func flip_up():
	#card_data.test_function(4)
	var all_cards : Array = get_tree().get_nodes_in_group("Card")
	print(all_cards)
	for card in all_cards:
		if card is Card:
			print("detected")
			#card.another_card_flipped(card)
		
	get_bottom_card().calculate_total_mana()


func another_card_flipped(flipped_card : Card):
	if flipped_card != self and flipped_up:
		print(self)
#func check_stack_upwards()->void:
	
	#clear_upwards()
	#total_stack_mana = card_data.mana_cost
	#var has_child_card : bool = false
	#for child in get_children():
		#if child is Card:
			#if !child.is_dragging:
				#has_child_card = true
			##if has child card and child IS in stack, check the legality of dropping and set self in stack if passed
			#if child.is_in_stack:
				#total_stack_mana += child.total_stack_mana
				#if is_legal_drop(child):
					#is_in_stack = true
					#draggable = true
					#update_data()
	##set in stack if no kids found (excluding dragged cards)
	#if !has_child_card and !drop_lock:
		#is_in_stack = true
		#draggable = true
		#total_stack_mana = card_data.mana_cost
		#update_data()
	##propagate up partents
	#if get_parent() is Card:
		#get_parent().check_stack_upwards()

func check_stack_upwards()->void:
	for child in get_children():
		if child is Card:
			if child.is_dragging:
				pass
			else:
				pass

func calculate_total_mana()->void:
	total_stack_mana = mana_cost
	if get_parent() is Card:
		var parent_card : Card = get_parent() 
		parent_card.calculate_total_mana()
		if !is_dragging and parent_card.flipped_up:
			total_stack_mana = parent_card.total_stack_mana + mana_cost
		else:
			total_stack_mana = mana_cost
	if is_dragging and hover_target:
		#print(hover_target.get_parent())
		if hover_target.get_parent() is Card:
			var target_card : Card = hover_target.get_parent()
			if target_card.flipped_up:
				total_stack_mana = hover_target.get_parent().get_bottom_card().total_stack_mana + mana_cost
		elif hover_target is StackZone:
			if hover_target.get_bottom_card() is Card and hover_target.get_bottom_card() != get_bottom_card():
				total_stack_mana = hover_target.get_bottom_card().total_stack_mana + mana_cost

#the check_legal should be re-used for shuffling but sheck if false instead of true
func is_legal_drop(target_card : Card)->bool:
	if target_card.drop_lock or !target_card.flipped_up:
		return false
	
	if get_bottom_card().total_stack_mana <= max_stack_cost:
		return true
	return false

func change_parent(new_parent : Node)->void:
	#call old parent's methods
	var old_parent = get_parent()
	var old_stack_zone : StackManagerY = get_manager_y()
	if old_parent is Card:
		if !old_parent.flipped_up:
			old_parent.flip_up()
		old_parent.get_bottom_card().calculate_total_mana()
	
	self.reparent(new_parent)
	global_scale = new_parent.global_scale
	current_card_stack = get_stack_zone()
	#call new parent's methods
	if new_parent is Card:
		pass
	if old_stack_zone:
		old_stack_zone.card_exited()
	if get_manager_y():
		get_manager_y().card_entered()
	update_position()
	get_bottom_card().calculate_total_mana()

func update_position()->void:
	if get_parent() is Card and get_manager_y():
		return_position = Vector2(0,get_manager_y().recalculated_card_gap)
	else:
		return_position = Vector2.ZERO

func get_bottom_card()->Card:
	for child in get_children():
		if child is Card:
			if !child.is_dragging:
				return child.get_bottom_card()
	return self

func get_top_card()->Card:
	var parent := get_parent()
	if parent is Card:
		return parent.get_top_card()
	return self

func get_next_card()->Card:
	for child in get_children():
		if child is Card:
			return child
	return null

func get_all_cards_below(cards_so_far:Array[Card])->Array[Card]:
	var cards_below : Array[Card] = cards_so_far
	cards_below.append(self)
	for child in get_children():
		if child is Card:
			child.get_all_cards_below(cards_below)
	return cards_below

func get_all_cards_not_dragging(cards_so_far:Array[Card])->Array[Card]:
	var cards_below : Array[Card] = cards_so_far
	if !is_dragging:
		cards_below.append(self)
		for child in get_children():
			if child is Card and !child.is_dragging:
				return child.get_all_cards_not_dragging(cards_below)
	return cards_below

func get_stack_zone()->StackZone:
	if get_parent() is Card:
		return get_parent().get_stack_zone()
	elif get_parent() is StackZone:
		return get_parent()
	else:
		return null


func get_manager_y()->StackManagerY:
	if get_parent() is Card:
		return get_parent().get_manager_y()
	elif get_parent() is StackZone:
		return get_parent().get_parent()
	else:
		return null

func set_children_z_index(index : int)->void:
	if "visual" in self:
		self.visual.z_index = index
	for node in get_children():
		if node is Card:
			if index>0:
				node.set_children_z_index(index+1)
			else:
				node.set_children_z_index(index)

#sets ignore list to all droppable nodes in nested children
#this is useful so nodes dont detect their own stack as viable drop targets
func update_ignore_list()->void:
	var temp_ignore_ist : Array[Droppable]
	#temp_ignore_ist.append(self)
	#var highest_parent : Card = get_top_card()
	#if highest_parent.get_parent() is StackZone:
		#temp_ignore_ist.append(highest_parent.get_parent())
	for child in get_all_children(self):
		if child is Droppable:
			temp_ignore_ist.append(child)
	drop_ignore_list = temp_ignore_ist

#this function only exits to remove yellow error from editor
func emit_all_signals()->void:
	quick_move.emit()
	update_last_moved_stack.emit()
