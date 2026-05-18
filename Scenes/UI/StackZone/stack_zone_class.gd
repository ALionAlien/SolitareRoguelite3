@tool
class_name StackZone
extends Droppable

#@export var ManagerX : ZoneHolder = null

func add_card(path : String, flipped : bool)->void:
	var card_packed : PackedScene = load(path)
	var new_card = card_packed.instantiate()
	if get_bottom_card() is Card:
		get_bottom_card().add_child(new_card)
	else:
		add_child(new_card)
	var game_nodes = get_tree().get_nodes_in_group("game")
	for i in game_nodes:
		new_card.connect("moved", i._card_moved)
	if flipped:
		new_card.flip_up(false)
	else:
		new_card.flip_down(false)

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

func get_next_card()->Card:
	for child in get_children():
		if child is Card:
			return child
	return null

#func _enter_tree()->void:
	#await self.ready
#
#func _exit_tree()->void:
	#await self.ready

#func card_entered()->void:
	#stack_changed.emit()
#
#func card_exited()->void:
	#stack_changed.emit()
