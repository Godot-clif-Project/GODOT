extends Node

onready var display_text = $MarginContainer/VBoxContainer/Display/ColorRect/MarginContainer/RichTextLabel

var first_number = ""
var second_number = ""
var operation = ""
var last_result = ""
var final_result = ""

var calculation_float: float
var calculation_int: int

func _ready():
	set_process(false)
	display_text.text = "0"

func _process(delta):
	if operation == "":
		display_text.text = first_number
	elif operation == "equal":
		display_text.text = str(calculation_int)
	else:
		display_text.text = second_number

func _on_Button_One_pressed():
	set_process(true)
	if operation == "":
		first_number = first_number + "1"
	else:
		second_number = second_number + "1"

func _on_Button_Two_pressed():
	set_process(true)
	if operation == "":
		first_number = first_number + "2"
	else:
		second_number = second_number + "2"

# --------------------------------------
func _on_Button_Plus_pressed():
	operation = "plus"

func calculation():
	if operation == "plus":
		var _plus = int(first_number) + int(second_number)
		operation = "equal"
		calculation_int = _plus

func _on_Button_Equal_pressed():
	calculation()
