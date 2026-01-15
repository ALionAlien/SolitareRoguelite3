@tool
class_name StackZone
extends Droppable

signal stack_changed
@export var ManagerX : StackManagerX = null
@export var ManagerY : StackManagerY

var is_empty : bool = true :
	set(variable):
		is_empty = variable
	get():
		return check_empty()
#change is empty to just check array made from get all cards
func check_empty()->bool:
	var children : Array = get_children()
	for node in children:
		if node is Card:
			return false
	return true

func get_all_cards_in_stack()->Array[Card]:
	var cards_below : Array[Card]
	for child in get_children():
		if child is Card:
			cards_below = child.get_all_cards_below(cards_below)
	return cards_below

func get_all_cards_not_dragging()->Array[Card]:
	var cards_below : Array[Card]
	for child in get_children():
		if child is Card and !child.is_dragging:
			return child.get_all_cards_not_dragging(cards_below)
	return cards_below

func card_entered()->void:
	stack_changed.emit()

func card_exited()->void:
	stack_changed.emit()
