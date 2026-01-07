extends RemoteTransform2D


func _process(delta):
	get_node(get_remote_node()).global_scale = lerp(get_node(get_remote_node()).global_scale, self.global_scale, 10 * delta)
