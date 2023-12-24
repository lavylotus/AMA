extends CharacterBody2D

signal EzDialogueStart

#arbitrary value but it feels good so ig it works
@export var player_speed = 100

@onready var canTalk = false
@onready var activeDialogue = false

func playAnimation(direction):
	if direction.x != 0:
		
		$AnimatedSprite2D.play("run")
		
		if direction.x > 0:
			$AnimatedSprite2D.flip_h = true
			
			$Area2D.position = Vector2(15,0) 
			
		elif direction.x < 0:
			$AnimatedSprite2D.flip_h = false
			
			$Area2D.position = Vector2(-15,0) 
			
	elif direction.y > 0:
		$AnimatedSprite2D.play("down")
		
		$Area2D.position = Vector2(0,15) 

	elif direction.y < 0:
		$AnimatedSprite2D.play("up")
		
		$Area2D.position = Vector2(0,-15)
	
	else:
		#makes sure that the animation will not go to idle if AMA is facing up, looks weird if disabled
		if $AnimatedSprite2D.animation == "up": 
			$AnimatedSprite2D.stop()
		else:
			$AnimatedSprite2D.play("idle")

func dialogueStart():
	#need to add rayCast2D collision here but haven't figured it out yet
	if Input.is_action_just_pressed("action_1") and canTalk:
		#need to move this to the animation portion, use the activeDialogue bool to select something
		$AnimatedSprite2D.stop()
		activeDialogue = true
		emit_signal("EzDialogueStart")

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
		
	#$Area2D.AreaCheck(direction)
	dialogueStart()

#how to move to new scenes. just like dialogue I can't wait to figure out storing these values and changing them
func _on_scene_transition_body_entered(_body):
	if Input.is_action_pressed("action_1"):
		get_tree().change_scene_to_file("res://Scenes/sample_scene_change.tscn")

func _on_dialogue_checker_area_entered(_area):
	print("I'm turned on I guess")
	canTalk = true
	
func _on_dialogue_checker_area_exited(_area):
	canTalk = false
