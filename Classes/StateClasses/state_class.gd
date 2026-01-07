class_name State
extends Node

var state_manager : StateManager

func _ready():
	state_manager = get_parent()

func enter_state()->void:
	pass

func exit_state()->void:
	pass

func update(_delta)->void:
	pass

func handle_input(_event : InputEvent)->void:
	pass

func set_state(new_state: State)->void:
	if state_manager and state_manager.has_method("change_state"):
		state_manager.state = new_state
