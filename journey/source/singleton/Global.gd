extends Node

var main_menu_scene: String = "res://source/UI/MainMenu.tscn"
var pause_menu_scene: String = "res://source/UI/PauseMenu.tscn"
var quit_scene: String = "res://source/UI/Quit.tscn"

var level_1_scene: String = "res://source/levels/Level1.tscn"
var level_2_scene: String = "res://source/levels/Level2.tscn"
var level_3_scene: String = "res://source/levels/Level3.tscn"
var level_4_scene: String = "res://source/levels/Level4.tscn"


func _ready() -> void:
	pass


func _input(event: InputEvent) -> void:
	# Pause Menu Action.
	# Main altinda "MainMenu" Node u yok ise ve escape tusuna basilirsa calisiyor.
	if event.is_action_pressed("ui_cancel"):
		if not get_tree().get_root().has_node("MainMenu"):
				var _pause_menu_source = load(pause_menu_scene)
				var _pause_menu_ins = _pause_menu_source.instance()
				get_tree().get_root().add_child(_pause_menu_ins)
				get_tree().paused = true
		else:
			print("You are NOT in game!")
