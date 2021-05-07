extends Control


onready var new_game_button: Button = $Buttons/NewGameButton
onready var continue_button: Button = $Buttons/ContinueButton
onready var options_button: Button = $Buttons/OptionsButton
onready var quit_button: Button = $Buttons/QuitButton


func _on_NewGameButton_pressed() -> void:
	SceneTransition.change_scene(Global.level_1_scene, 0.1)


func _on_ContinueButton_pressed() -> void:
	pass # Replace with function body.


func _on_OptionsButton_pressed() -> void:
	pass # Replace with function body.


func _on_QuitButton_pressed() -> void:
	SceneTransition.change_scene(Global.quit_scene, 0.1)


func _enter_tree() -> void:
	print("{name} entered tree!".format({"name": self.name}))


func _ready() -> void:
	get_tree().paused = false
	new_game_button.grab_focus() # Focus for control.


func _exit_tree() -> void:
	print("{name} exited tree!".format({"name": self.name}))
	self.queue_free()
