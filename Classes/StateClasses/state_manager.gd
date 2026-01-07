class_name StateManager
extends Node

var state : State :
	set(value):
		update_state(state, value)
		state = value
	get:
		return state

func update_state(old_state: State, new_state : State)->void:
	if old_state and old_state.has_method("exit_state"):
		state.exit_state()
	if new_state and new_state.has_method("enter_state"):
		new_state.enter_state()

func _input(event):
	if state and state.has_method("handle_input"):
		state.handle_input(event)

func _physics_process(delta):
	if state and state.has_method("update"):
		state.update(delta)
