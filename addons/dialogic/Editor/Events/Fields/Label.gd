@tool
extends Control


@export var text: String = "Hello World"


func _ready():
	$Label.text = text
	$Label.set('theme_override_colors/font_color', Color("#7b7b7b"))

