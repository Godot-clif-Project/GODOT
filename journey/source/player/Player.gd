extends KinematicBody2D

## -------------------------------------------------------------------------- ##
## VARIABLES
## -------------------------------------------------------------------------- ##

onready var state_label: Label = $DebugLabels/StateLabel
onready var backtrail: Line2D = $BodySprite/BackTrailLine
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var spawn_particles: CPUParticles2D = $SpawnCPUParticles
onready var dash_timer: Timer = $DashTimer

const FLOOR_NORMAL = Vector2.UP

var velocity: Vector2 = Vector2.ZERO

var max_move_speed: float = 200.0
var max_jump_speed: float = 350.0
var max_dash_speed: float = 1200.0

# GRAVITY
var max_gravity: float = 1000.0 setget _set_max_gravity
var default_gravity: float = 1000.0
var double_jump_gravity: float = 1250.0

var max_jump_count: int = 2
var current_jump_count: int
var can_dash: bool
var dashing_time: float = 0.4

var is_dashing: bool
var is_left_side_touching: bool
var is_right_side_touching: bool

var is_dead: bool

var player_start_position: Vector2

## -------------------------------------------------------------------------- ##
## SIGNALS
## -------------------------------------------------------------------------- ##

func _on_LeftArea_body_entered(_body: Node) -> void:
	is_left_side_touching = true

func _on_LeftArea_body_exited(_body: Node) -> void:
	is_left_side_touching = false

func _on_RightArea_body_entered(_body: Node) -> void:
	is_right_side_touching = true

func _on_RightArea_body_exited(_body: Node) -> void:
	is_right_side_touching = false

func _on_DashTimer_timeout() -> void:
	is_dashing = false

## -------------------------------------------------------------------------- ##
## FUNCTIONS
## -------------------------------------------------------------------------- ##

func _set_max_gravity(value):
	max_gravity = value


func gravity(delta) -> void:
	if not is_dashing: velocity.y += max_gravity * delta
	if velocity.y >= max_gravity: velocity.y = max_gravity


func move() -> void: # Left and Right Movement
	velocity.x = lerp(velocity.x, max_move_speed * _get_move_strength(), 0.2)


func jump(delta) -> void: # Jump
	if not _get_side_touch():
		if is_on_floor():
			current_jump_count = max_jump_count
	
		if Input.is_action_just_pressed("jump") and current_jump_count > 0:
			if velocity.y > 0.0: velocity.y = 0.0
			velocity.y -= max_jump_speed + (max_gravity * delta)
			current_jump_count -= 1
			
		if Input.is_action_just_released("jump") and velocity.y <= 0.0:
			velocity.y = 0.0


func wall_jump(delta) -> void:
	if _get_side_touch():
		current_jump_count = max_jump_count

		if Input.is_action_just_pressed("jump") and _get_side_touch() and current_jump_count > 0:
			if velocity.y > 0.0: velocity.y = 0.0
			velocity.y -= max_jump_speed + (max_gravity * delta)
			
			if is_left_side_touching:
				velocity.x += max_jump_speed * 1.5
			if is_right_side_touching:
				velocity.x -= max_jump_speed * 1.5
	
		if Input.is_action_just_released("jump") and velocity.y <= 0.0:
			velocity.y = 0.0


func dash() -> void:
	if is_on_floor():
		can_dash = true

	if Input.is_action_just_pressed("dash") and can_dash and not is_on_floor():
		if not _get_move_direction() == 0.0:
			velocity = Vector2(_get_move_direction() * max_dash_speed, 0)
			can_dash = false
			is_dashing = true
			dash_timer.wait_time = dashing_time
			dash_timer.start()


func dead():
	backtrail.clear_points()
	self.position = player_start_position
	animation_player.play("spawn")
	_spawn_particles()


func _spawn_particles() -> void:
	spawn_particles.z_index = 1
	spawn_particles.emitting = true
	yield(get_tree().create_timer(0.3), "timeout")
	spawn_particles.z_index = 0


func _get_move_strength() -> float:
	var left: float = Input.get_action_strength("move_left")
	var right: float = Input.get_action_strength("move_right")
	var out: float =  right - left
	return out


func _get_move_direction() -> float:
	var out: float
	if _get_move_strength() > 0:
		out =  1.0
	elif _get_move_strength() < 0:
		out = -1.0
	else:
		out = 0.0
	return out


func _get_move_input() -> bool:
	var _l = Input.is_action_pressed("move_left")
	var _r = Input.is_action_pressed("move_right")
	var out: bool = true if _l or _r else false
	return out


func _get_side_touch():
	return is_left_side_touching or is_right_side_touching


func _ready() -> void:
	player_start_position = self.position


func _physics_process(delta: float) -> void:
	move()
	jump(delta)
	wall_jump(delta)
	dash()
	gravity(delta)

	velocity = move_and_slide(velocity, FLOOR_NORMAL)

