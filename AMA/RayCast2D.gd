extends RayCast2D

func _process(delta):
	if is_colliding():
		emit_signal("_on_dialogue_body_entered")
		
	else:
		emit_signal("_on_dialogue_body_exited"
