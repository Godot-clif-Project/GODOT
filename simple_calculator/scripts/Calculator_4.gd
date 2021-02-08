extends Node

onready var display_text = get_node("MCont/VCont/Display/ColorRect/MCont/Display")
onready var buttons = get_node("MCont/VCont/ButtonsPad/ColorRect/MarginContainer/GridContainer")
onready var operation_text = get_node("MCont/VCont/OperationLabel")

var number = ""
var first_num = ""
var second_num = ""
var operation = ""


func _ready() -> void:
	display_text.text = ""
	
	for button in buttons.get_children():
		button.connect("pressed", self, "_on_button_pressed", 
				[button.name, button.text, button.get_groups()])


func _process(delta):
	pass


func _on_button_pressed(name, text, group):
	
	if group[0] == 'number':
		display_text.text += text
	if group[0] == 'convert':
		if name == 'Button_Point':
			display_text.text += text


func calculation(op, num1, num2):
	if op == 'addition':
		var result = float(num1) + float(num2)
		return result