extends Node

@export var friendly_zones : ZoneLineup
@export var Enemy_zones : EnemyZoneLineup


func _on_call_cards_pressed():
	trigger_ability("enemy_dealt_damage")

func trigger_ability(method : String)->void:
	var all_cards : Array[Card] = get_all_friendly_cards()
	all_cards.append_array(get_all_enemy_cards())
	for card in all_cards:
		card.call(method)

func get_all_friendly_cards()->Array[Card]:
	var array : Array[Card] = []
	for stack in friendly_zones.stacks:
		array.append_array(stack.zone.get_all_cards_in_stack())
	return array


func get_all_enemy_cards()->Array[Card]:
	var array : Array[Card] = []
	for stack in Enemy_zones.stacks:
		array.append_array(stack.zone.get_all_cards_in_stack())
	return array
