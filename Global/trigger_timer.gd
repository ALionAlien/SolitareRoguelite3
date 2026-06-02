extends Node

@export var trigger_timer_min : float = 0.15
@export var trigger_timer_additional : float = 0.15
#how much the 'trigger timer additional' gets divided by each process
@export var trigger_timer_step : float = 0.93
var trigger_timer_additional_temp : float
var trigger_duration : float = 0.3 :
	set(value):
		trigger_duration = value
	get():
		trigger_duration = trigger_timer_min + trigger_timer_additional_temp
		return trigger_duration

func reset_duration()->void:
	trigger_timer_additional_temp = trigger_timer_additional
	trigger_duration = trigger_timer_min + trigger_timer_additional

func increase_speed()->void:
	trigger_timer_additional_temp = trigger_timer_additional_temp * trigger_timer_step
	trigger_duration = trigger_timer_min + trigger_timer_additional_temp
