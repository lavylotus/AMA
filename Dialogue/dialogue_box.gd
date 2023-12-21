extends Node2D

@onready var choice_button_scn = preload("res://Dialogue/choice_button.tscn")

var choice_buttons: Array[Button] = []
var is_dialogue_done = false

func clear_dialogue_box():
	$VBoxContainer/Label.text = ""
	for choice in choice_buttons:
		$VBoxContainer.remove_child(choice)
		choice.queue_free()
		choice_buttons = []

func add_text(text: String):
	$VBoxContainer/Label.text = text
	
func add_choice(choice_text: String):
	var button_obj: ChoiceButton = choice_button_scn.instantiate()
	button_obj.choice_index = choice_buttons.size()
	choice_buttons.push_back(button_obj)
	button_obj.text = choice_text
	$VBoxContainer.add_child(button_obj)
	button_obj.choice_selected.connect(_on_choice_selected)
	
func _on_choice_selected(choice_index: int):
	if !is_dialogue_done:
		($"../EzDialogue" as EzDialogue).next(choice_index)
	else:
		clear_dialogue_box()
