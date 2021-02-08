extends Control


onready var new_game_button: Button = $Buttons/NewGameButton
onready var quit_button: Button = $Buttons/QuitButton


func _on_NewGameButton_pressed() -> void:
	SceneTransition.change_scene(Global.level_1_scene, 0.1)


func _on_QuitButton_pressed() -> void:
	SceneTransition.change_scene(Global.quit_scene, 0.1)


func _ready() -> void:
	new_game_button.grab_focus()
