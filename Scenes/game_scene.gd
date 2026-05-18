extends Node2D

@export var friendly_zones : FriendlyZoneLineup
@export var enemy_zones : EnemyZoneLineup
@export var test_label : TextEdit
@export var mouse_manager : MouseManager
@export var trigger_timer : Timer


func _ready()->void:
	SaveManager.load_game()



func _on_save_pressed()->void:
	SaveManager.save_game()


func _on_modify_data_pressed()->void:
	SaveManager.data.test = "changed data"
	print(SaveManager.data.test)


func _on_load_pressed()->void:
	SaveManager.load_game()



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
	for stack in enemy_zones.get_stacks():
		if stack.has_card():
			stack.process_attack()
			return
	trigger_timer.stop()
	mouse_manager.can_drag = true

#whenever a card is moved it emits a signal that calls this function
#the signal connect method is in the stacksone class in the add_card function
func _card_moved(_moved_card : Card)->void:
	recaultulate_stacks()
	_on_trigger_tick_timeout()
	mouse_manager.can_drag = false
	trigger_timer.start()
