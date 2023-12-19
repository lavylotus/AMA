extends CharacterBody2D

func _process(delta):
	if $AnimatedSprite2D.animation != "break":
		$AnimatedSprite2D.play("idle")
	
	#somewhere between 30 and 120 seconds per 'breakdown'
	var breakTime = randi() % 90 + 30
	await get_tree().create_timer(breakTime).timeout
	queue_free()
	$AnimatedSprite2D.play("break")
	#wait 5 seconds for the animation to complete before idling again
	await get_tree().create_timer(5).timeout
	queue_free()
