extends Card

@export var visual : CardVisual

func _ready():
	update_data()

func update_data()->void:
	var background : TextureRect = visual.background
	visual.card_label.text = str(colors_array)
	if drop_lock:
		background.modulate =  Color(0.5, 0.5, 0.5, 1) #grayed out
	#elif is_dragging:
		#$Sprite2D.modulate =  Color(1.25, 1.25, 1.25, 1) #highlighted
	elif is_in_stack and !is_hovering:
		background.modulate =  Color(0.5, 0.8, 0.5, 1) #green
	elif is_in_stack and is_hovering:
		background.modulate = Color(0.7, 1.0, 0.7, 1) #green
	elif is_hovering:
		background.modulate =  Color(1.2, 1.2, 1.2, 1) #highlighted
	else:
		background.modulate =  Color(1, 1, 1, 1) #normal

func hover_entered()->void:
	super.hover_entered()
	var tween = create_tween()
	tween.tween_property(visual, "scale", Vector2(1.03,1.03), 0.1) \
	.set_trans(Tween.TRANS_EXPO) \
	.set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(0.7).timeout
	if is_hovering and !is_dragging:
		#$Panel.show()
		pass

func hover_exited()->void:
	super.hover_exited()
	#$Panel.hide()
	var tween = create_tween()
	tween.tween_property(visual, "scale", Vector2(1.0,1.0), 0.1) \
	.set_trans(Tween.TRANS_EXPO) \
	.set_ease(Tween.EASE_OUT)


func clicked()->void:
	quick_move.emit(self)

func flip_up():
	flipped_up = true
	get_bottom_card().check_stack_upwards()
	var tween = create_tween()
	tween.tween_property(visual, "rotation_y", 0, 0.6) \
	.set_trans(Tween.TRANS_SINE)
	

func flip_down():
	flipped_up = false
	var tween = create_tween()
	tween.tween_property(visual, "rotation_y", 180, 0.6) \
	.set_trans(Tween.TRANS_SINE)
