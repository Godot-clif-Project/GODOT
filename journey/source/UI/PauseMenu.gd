extends Control


onready var continue_button: Button = $Buttons/ContinueButton
onready var options_button: Button = $Buttons/OptionsButton
onready var main_menu_button: Button = $Buttons/MainMenuButton


func _on_ContinueButton_pressed() -> void:
	get_tree().paused = false
	self.queue_free()


func _on_OptionsButton_pressed() -> void:
	pass # Replace with function body.


func _on_MainMenuButton_pressed() -> void:
	get_tree().paused = false
	SceneTransition.change_scene(Global.main_menu_scene, 0.1)
	self.queue_free()


func _enter_tree() -> void:
	print("{name} entered tree!".format({"name": self.name}))


func _ready() -> void:
	continue_button.grab_focus() # Focus for control.


func _exit_tree() -> void:
	print("{name} exited tree!".format({"name": self.name}))


