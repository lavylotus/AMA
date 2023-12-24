extends Node2D

@export var dialogueJSON : JSON 

@onready var target = $"../../AMA"

@onready var state = {
	"show_only_one" : false,
	"player_name" : "AMA",
	"value" : 0
}

func _ready():
	var startFunction = target
	startFunction.EzDialogueStart.connect(EzDialogueStart)
	hide()

func EzDialogueStart():
	($EzDialogue as EzDialogue).start_dialogue(dialogueJSON, state)
	show()
	print("EzDialogueStart")
	
func _on_ez_dialogue_dialogue_generated(response: DialogueResponse):
	print("EzDialogue_generated")
	$dialogue_box.clear_dialogue_box()
	
	$dialogue_box.add_text(response.text)
	
	print(response.choices)
	if response.choices.is_empty() && target.activeDialogue == true:
		$dialogue_box.add_choice("v")
		
	else: 
		for choice in response.choices:
			$dialogue_box.add_choice(choice)


func _on_ez_dialogue_custom_signal_received(value: String):
	print("EzDialogue_custom_signal_recieved")
	var params = value.split(",")
	if params[0] == "set":
		var variable_name = params[1]
		var variable_value = params[2]
		state[variable_name] = variable_value 


func _on_ez_dialogue_end_of_dialogue_reached():
	print("EzDialogue_ended")
	$dialogue_box.is_dialogue_done = true
	target.activeDialogue = false
	hide()
