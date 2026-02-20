@tool
class_name EnemyZoneLineup
extends ZoneLineup

var enemy_holder_scene : PackedScene = preload("res://Scenes/UI/EnemyStacks/enemy_zone_holder.tscn")


func _on_add_enemy_stack_pressed():
	add_zone(enemy_holder_scene)
