extends KinematicBody2D


var speed: float = 200
var velocity: Vector2 = Vector2.ZERO

func get_input() -> void:
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.x += 1

	velocity = velocity.normalized() * speed


func _process(_delta: float) -> void:
	self.look_at(get_global_mouse_position())


func _physics_process(delta: float) -> void:
	get_input()
	velocity = move_and_slide(velocity)
