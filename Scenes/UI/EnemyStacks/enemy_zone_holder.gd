@tool
class_name EnemyZoneHolder
extends Control

@export var width : float = 180.0 : 
	set(value):
		custom_minimum_size.x = width
		width = value 
