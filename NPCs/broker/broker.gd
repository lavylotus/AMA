extends CharacterBody2D

func _process(_delta):
	if $AnimatedSprite2D.animation != "break":
		$AnimatedSprite2D.play("idle")
		
#somewhere between 30 and 120 seconds per 'breakdown'
#wait 5 seconds for the animation to complete before idling again
func _on_animation_timer_timeout():
	$AnimatedSprite2D.play("break")
	await get_tree().create_timer(5).timeout
	$AnimatedSprite2D.play("idle")
