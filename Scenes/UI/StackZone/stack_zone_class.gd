@tool
class_name StackZone
extends Droppable

signal stack_changed
@export var ManagerX : StackManagerX = null
@export var ManagerY : StackManagerY = null

func has_cards() -> bool:
	var card : Card = get_bottom_card()
	if card:
		return true
	else:
		return false

func get_all_cards_in_stack()->Array[Card]:
	var cards_below : Array[Card]
	for child in get_children():
		if child is Card:
			cards_below = child.get_all_cards_below(cards_below)
	return cards_below

func get_bottom_card()->Card:
	for child in get_children():
		if child is Card:
			return child.get_bottom_card()
	return null

func get_all_cards_not_dragging()->Array[Card]:
	var cards_below : Array[Card]
	for child in get_children():
		if child is Card and !child.is_dragging:
			return child.get_all_cards_not_dragging(cards_below)
	return cards_below

func _enter_tree()->void:
	await self.ready

func _exit_tree()->void:
	await self.ready

func card_entered()->void:
	stack_changed.emit()

func card_exited()->void:
	stack_changed.emit()
