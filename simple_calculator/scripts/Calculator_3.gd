extends Node

onready var display_text = get_node("MCont/VCont/Display/ColorRect/MCont/Display")
onready var buttons = get_node("MCont/VCont/ButtonsPad/ColorRect/MarginContainer/GridContainer")

var operator = ""
var number = ""
var first_num = ""
var second_num = ""


func _ready():
	display_text.text = ""
	
	for button in buttons.get_children():
		button.connect("pressed", self, "_on_button_pressed", [button.name, button.text])


func _on_button_pressed(name, text):

	if text.is_valid_integer():
		if operator == "":
			display_text.text += text
			number = display_text.text
			first_num = number
		elif operator in ["+", "-", "/", "*"]:
			display_text.text += text
			number = display_text.text
			second_num = number
			var new_number = str(int(first_num) + int(second_num))
			first_num = new_number
			display_text.text = new_number
			operator = ""
		else:
			pass

	elif text == "+":
		operator = "+"
		display_text.text = ""