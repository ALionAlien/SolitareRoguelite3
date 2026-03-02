class_name SaveData
extends Resource

enum last_screen {MAP, BATTLE, SHOP}

var game_scene : PackedScene

var friendly_stack_scene : PackedScene = preload("res://Scenes/UI/FriendlyZone/friendly_zone_holder.tscn")

var stacks : Array[PackedScene]
var enemies : Array

func create_empty_save()->void:
	stacks = []
	for i in 3:
		stacks.append(friendly_stack_scene)
