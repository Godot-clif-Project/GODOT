extends Node

onready var display_text = $MCont/VCont/Display/ColorRect/MarginContainer/RichTextLabel

var number = ""
var first_number = ""
var second_number = ""
var operation = ""
var final_result = ""

func _ready():
	set_process(false)
	display_text.text = "0"

func _process(delta):
	pass

func display_update(value):
	display_text.text = str(value)

func _on_Button_Seven_pressed():
	first_number = first_number + "7"
	display_update(first_number)

func _on_Button_Plus_pressed():
	operation = "+"


func _on_Button_Equal_pressed():
	operation = "" # operation emty
