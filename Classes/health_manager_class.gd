class_name HealthManager
extends Node

signal damage_blocked

var health : int

@export var max_heath : int = 100 :
	set(value):
		max_heath = value
	get():
		return max_heath

func set_max_health():
	health = max_heath
