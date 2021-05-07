extends Node

# Some notes here
# Some notes again

func _unhandled_input(event):
	# Escape Key pressed to quit
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
