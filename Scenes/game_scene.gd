extends Node2D

@export var friendly_zones : FriendlyZoneLineup
@export var enemy_zones : EnemyZoneLineup
@export var test_label : TextEdit
@export var mouse_manager : MouseManager
@export var trigger_timer : Timer

@export var trigger_timer_min : float = 0.5
@export var trigger_timer_additional : float = 0.5
#how much the 'trigger timer additional' gets divided by each process
@export var trigger_timer_step : float = 0.3
var trigger_timer_additional_temp : float
var trigger_duration_total : float


func _ready()->void:
	SaveManager.load_game()



func _on_save_pressed()->void:
	SaveManager.save_game()


func _on_modify_data_pressed()->void:
	SaveManager.data.test = "changed data"
	print(SaveManager.data.test)


func _on_load_pressed()->void:
	SaveManager.load_game()


func save_data():
	set_ownership(self, self)
	var ui_scene = PackedScene.new()
	ui_scene.pack(get_tree().get_current_scene())
	SaveManager.data.game_ui = ui_scene

func set_ownership(p_owner, node):    
	for c in node.get_children():    
		c.owner = p_owner
		set_ownership(p_owner, c)


func _on_call_cards_pressed()->void:
	trigger_ability("enemy_dealt_damage")

func trigger_ability(method : String)->void:
	var all_cards : Array[Card] = get_all_friendly_cards()
	all_cards.append_array(get_all_enemy_cards())
	for card in all_cards:
		card.call(method)

func get_all_friendly_cards()->Array[Card]:
	var array : Array[Card] = []
	for stack in friendly_zones.get_stacks():
		array.append_array(stack.zone.get_all_cards_in_stack())
	return array


func get_all_enemy_cards()->Array[Card]:
	var array : Array[Card] = []
	for stack in enemy_zones.get_stacks():
		array.append_array(stack.zone.get_all_cards_in_stack())
	return array

func recaultulate_stacks()->void:
	pass




func _on_trigger_tick_timeout()->void:
	process_cards()


func process_cards()->void:
	trigger_timer.wait_time = TriggerTimer.trigger_duration
	TriggerTimer.increase_speed()
	
	#check/run flip triggers
	#
	
	#flip que
	var cards_to_flip : Array = get_tree().get_nodes_in_group("que_flip")
	var filtered_cards_to_flip : Array[Card]
	#filter only cards
	for node in cards_to_flip:
		if node is Card:
			filtered_cards_to_flip.append(node)
	
	#sort by number left/right top/bottom
	#if filtered_cards_to_flip.size() > 1:
	
	if !filtered_cards_to_flip.is_empty():
		filtered_cards_to_flip[0].flip_up(true)
		filtered_cards_to_flip[0].remove_from_group("que_flip")
	
	
	#process cards in enemy zones
	for stack in enemy_zones.get_stacks():
		if stack.has_card():
			stack.process_attack()
			return
	#process enemy attacks
	for stack in enemy_zones.get_stacks():
		if stack.action_remaining == 0:
			#stack. attack here
			stack.action_remaining = stack.action_count
			return
	trigger_timer.stop()
	mouse_manager.can_drag = true

#whenever a card is moved it emits a signal that calls this function
#the signal connect method is in the stacksone class in the add_card function
func _card_moved(_moved_card : Card)->void:
	recaultulate_stacks()
	mouse_manager.can_drag = false
	for stack in enemy_zones.get_stacks():
		stack.action_remaining -= 1
	_on_trigger_tick_timeout()
	TriggerTimer.reset_duration()
	trigger_timer.start()
