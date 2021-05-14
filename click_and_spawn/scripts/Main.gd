extends Node2D

onready var ball: PackedScene = preload("res://scenes/Ball.tscn")
onready var container: Node = $BallContainer
onready var HUD: Control = get_node("HUD")

var mouse_position: Vector2


func _ready() -> void:
	pass


func _physics_process(delta) -> void:
	OS.set_window_title("| FPS : " + str(Engine.get_frames_per_second()))
	mouse_position = get_viewport().get_mouse_position()
	HUD.ball_count_label.text = str(container.get_child_count())


func ball_spawn() -> void:
	var new_ball = ball.instance()
	container.add_child(new_ball)
	new_ball.position = mouse_position


func _input(event) -> void:
	if event is InputEventMouseButton:
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			for i in rand_range(1, 10):
				ball_spawn()
