extends ProgressBar

var damage_bar_tween : Tween

func _on_value_changed(updated_value):
	if damage_bar_tween and damage_bar_tween.is_valid():
		damage_bar_tween.kill() # Stops the old tween immediately
	damage_bar_tween = create_tween()
	damage_bar_tween.tween_property($DamageBar, "value", updated_value, TriggerTimer.trigger_duration-0.1) 
