extends CharacterBody2D

#arbitrary value but it feels good so ig it works
@export var player_speed = 100

#for SOME REASON canTalk will be set to true when the scene loads due to _on_dialogue_body_entered running for fun
#there's likely a better way to do this, hopefully removing canTalk from being a switch and more of a constant
#with the raycast2D

@export var canTalk = false
@export var activeDialogue = false

#temporary timeline to figure out how dialogue works
@export var timeline = "res://Dialogue/timeline.dtl"

func playAnimation(direction):
	if direction.x != 0:
		
		$AnimatedSprite2D.play("run")
		
		if direction.x > 0:
			$AnimatedSprite2D.flip_h = true
		
		elif direction.x < 0:
			$AnimatedSprite2D.flip_h = false
	
	elif direction.y > 0:
		$AnimatedSprite2D.play("down")	
	
	elif direction.y < 0:
		$AnimatedSprite2D.play("up")
	
	else:
		#makes sure that the animation will not go to idle if AMA is facing up, looks weird if disabled
		if $AnimatedSprite2D.animation == "up": 
			$AnimatedSprite2D.stop()
		else:
			$AnimatedSprite2D.play("sleepy")

#the _on_dialogue things need to be reattached, was making the raycast be the detector but got frustrated

func _on_dialogue_body_entered(_body):
	canTalk = true

func _on_dialogue_body_exited(_body):
	#no idea if I need this but it feels like good practice?
	Dialogic.end_timeline()
	canTalk = false

func dialogueStart():
	#need to add rayCast2D collision here but haven't figured it out yet
	if Input.is_action_pressed("talk") and canTalk:
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		#excited to figure out how to manage timelines, hopefully inside of the NPCS
		Dialogic.start(timeline)
		
		#need to move this to the animation portion, use the activeDialogue bool to select something
		$AnimatedSprite2D.stop()
		activeDialogue = true

func _on_timeline_ended():
	#dialogic confuses the fuck out of me
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	activeDialogue = false

func _process(_delta):
	#direction has to be constantly defined or else the raycasts won't rotate with the player
	var direction = Vector2(
	Input.get_action_strength("right") - Input.get_action_strength("left"),
	Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	direction = direction.normalized()
	
	if activeDialogue == false:
		velocity = direction * player_speed

		set_velocity(velocity)
		move_and_slide()
		playAnimation(direction)
	
	#if there's active dialogue don't move
	else:
		velocity = Vector2(0,0)
		
	rayCastCheck(direction)
	dialogueStart()

#how to move to new scenes. just like dialogue I can't wait to figure out storing these values and changing them
func _on_scene_transition_body_entered(_body):
	if Input.is_action_pressed("dialogic_default_action"):
		get_tree().change_scene_to_file("res://Scenes/sample_scene_change.tscn")

#lets fucking go, raycast code in the character controller bc it breaks if I make it a simpleton
func rayCastCheck(direction):
	if direction.x > 0:
		#cast to the right
		$RayCast2D.set_target_position(Vector2(25,0))
	elif direction.x < 0:
		#cast to the left
		$RayCast2D.set_target_position(Vector2(-25,0))
	elif direction.y > 0:
		#cast up
		$RayCast2D.set_target_position(Vector2(0,25))
	elif direction.y < 0:
		#cast down
		$RayCast2D.set_target_position(Vector2(0,-25))
		
	
