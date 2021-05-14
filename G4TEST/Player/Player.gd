extends KinematicBody

var max_walk_speed = 5
var max_run_speed = 10
var acceleration = 5
var deceleration = 10

var gravity = 9.8
var jump_height = 5

var mouse_sensitivity_x: float = 0.05
var mouse_sensitivity_y: float = 0.075

onready var head = $Head
onready var camera = $Head/Camera
onready var floor_rays = $FloorRays
onready var feet: CollisionShape = $FeetCollision

var velocity = Vector3.ZERO
var direction = Vector3.ZERO

var camera_x_rotation = 0
var camera_x_rotation_limit: float = 80.0
var camera_change = Vector2.ZERO

const FLY_SPEED = 40
const FLY_ACCEL = 4


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	if event is InputEventMouseMotion:
		camera_change = event.relative


func _process(_delta: float) -> void:
	aim()


func _physics_process(delta):
	apply_gravity(delta)
	jump()
	walk(delta)
	
	if get_is_on_floor():
		feet.set_deferred("disabled", false)
	else:
		feet.set_deferred("disabled", true)


func aim():
	if camera_change.length() > 0:
		
		# tum karakteri donduruyorum, ayaklarin yonunu kullanmak icin!
		self.rotate_y(deg2rad(-camera_change.x * mouse_sensitivity_y))

		var x_delta = camera_change.y * mouse_sensitivity_x
		if camera_x_rotation + x_delta > -camera_x_rotation_limit and camera_x_rotation + x_delta < camera_x_rotation_limit: 
			head.rotate_x(deg2rad(-x_delta))
			camera_x_rotation += x_delta

		camera_change = Vector2.ZERO



func apply_gravity(delta):
	velocity.y -= gravity * delta


func get_direction():
	# reset the direction of the player
	direction = Vector3.ZERO
	
	# get the rotation of the camera
	var head_basis = head.get_global_transform().basis
	
	# check input and change direction
	if Input.is_action_pressed("move_forward"):
		direction -= head_basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += head_basis.z

	if Input.is_action_pressed("move_left"):
		direction -= head_basis.x
	elif Input.is_action_pressed("move_right"):
		direction += head_basis.x

	direction = direction.normalized()
	return direction


func jump():
	if Input.is_action_just_pressed("jump") and get_is_on_floor():
		velocity.y = jump_height


func walk(delta):

	var temp_velocity = velocity
	temp_velocity.y = 0
	
	var speed
	if Input.is_action_pressed("run"):
		speed = max_run_speed
	else:
		speed = max_walk_speed

	# where would the player go at max speed
	var target_speed = get_direction() * speed
	
	var friction
	if get_direction().dot(temp_velocity) > 0:
		friction = acceleration
	else:
		friction = deceleration
	
	# calculate a portion of the distance to go
	temp_velocity = temp_velocity.linear_interpolate(target_speed, friction * delta)
	
	velocity.x = temp_velocity.x
	velocity.z = temp_velocity.z
	
	# move
	velocity = move_and_slide(velocity, Vector3.UP)


func fly(delta):

	# reset the direction of the player
	direction = Vector3()
	
	# get the rotation of the camera
	var head_basis = camera.get_global_transform().basis
	
	# check input and change direction
	if Input.is_action_pressed("move_forward"):
		direction -= head_basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += head_basis.z

	if Input.is_action_pressed("move_left"):
		direction -= head_basis.x
	elif Input.is_action_pressed("move_right"):
		direction += head_basis.x

	direction = direction.normalized()
	
	# where would the player go at max speed
	var target_speed = direction * FLY_SPEED
	
	# calculate a portion of the distance to go
	velocity = velocity.linear_interpolate(target_speed, FLY_ACCEL * delta)
	
	# move
	velocity = move_and_slide(velocity)


func get_is_on_floor():
	var ray = floor_rays.get_children()
	if ray[0].is_colliding() or ray[1].is_colliding() or ray[2].is_colliding() or ray[3].is_colliding():
		return true
	else:
		return false
