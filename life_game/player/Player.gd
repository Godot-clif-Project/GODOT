extends KinematicBody2D

signal player_state

onready var _transitions: Dictionary = {
		IDLE: [WALK, CROUCH, WALK, RUN],
		CROUCH: [WALK, RUN, IDLE],
		WALK: [IDLE, CROUCH, RUN],
		RUN: [IDLE, WALK, CROUCH],
		}
onready var stamina_drop_timer: Timer = $StaminaDropTimer
onready var stamina_rise_timer: Timer = $StaminaRaiseTimer

enum {IDLE, CROUCH, WALK, RUN}

var states_strings: Dictionary = {
		IDLE: "idle",
		CROUCH: "crouch",
		WALK: "walk",
		RUN: "run",
		}

#Inputs Variables
## -------------------------------------------
var up_input: bool = Input.is_action_pressed("ui_up")
var down_input: bool = Input.is_action_pressed("ui_down")
var left_input: bool = Input.is_action_pressed("ui_left")
var right_input: bool = Input.is_action_pressed("ui_right")
# ON / OFF Inputs
var run_input_press: bool = Input.is_action_just_pressed("run")
var run_input_releas: bool = Input.is_action_just_released("run")
var crouch_input_press: bool = Input.is_action_just_pressed("crouch")
var crouch_input_releas: bool = Input.is_action_just_released("crouch")
## -------------------------------------------


var _state: int
var is_walking: bool
var is_running: bool
var is_crouching: bool


var velocity: Vector2 = Vector2.ZERO
var crouch_speed: float = 50.0
var walk_speed: float = 100.0
var run_speed: float = 200.0
#var friction: float = 0.2

var stamina: float = 100.0
var max_stamina: float = 100.0


func _ready():
	_state = IDLE


func _process(delta):
	pass


func state_machine(delta):
	match _state:
		IDLE:
			if velocity:
				change_state(WALK)
				is_walking = true
		CROUCH:
			if not velocity:
				change_state(IDLE)
				is_walking = false
			if velocity and not is_crouching:
				change_state(WALK)
			if is_running:
				change_state(RUN)
				is_walking = false
		WALK:
			if not velocity:
				change_state(IDLE)
				is_walking = false
			if is_crouching:
				change_state(CROUCH)
				is_walking = false
			if is_running:
				change_state(RUN)
				is_walking = false
		RUN:
			if not velocity:
				change_state(IDLE)
				is_walking = false
			if is_crouching:
				change_state(CROUCH)
				is_walking = false
			if velocity and not is_running:
				change_state(WALK)
				is_walking = true


func enter_state() -> void:
	match _state:
		IDLE:
			emit_signal("player_state", states_strings[IDLE])
			stamina_drop_timer.stop()
			stamina_rise_timer.start(0.1)
		CROUCH:
			emit_signal("player_state", states_strings[CROUCH])
			stamina_drop_timer.start(0.8)
			stamina_rise_timer.stop()
		WALK:
			emit_signal("player_state", states_strings[WALK])
			stamina_drop_timer.stop()
			stamina_rise_timer.start(0.5)
		RUN:
			emit_signal("player_state", states_strings[RUN])
			stamina_drop_timer.start(0.1)
			stamina_rise_timer.stop()
		_:
			return


func change_state(target_State: int) -> void:
	if not target_State in _transitions[_state]:
		return
	_state = target_State
	enter_state()


func _unhandled_key_input(event):
	if event.is_action_pressed("run"):
		if not is_crouching:
			is_running = true
	elif event.is_action_released("run"):
		is_running = false
	
	if event.is_action_pressed("crouch"):
		if not is_running:
			is_crouching = true
	elif event.is_action_released("crouch"):
		is_crouching = false


func get_motion_input(delta):
#Inputs Variables
	## -------------------------------------------
	up_input = Input.is_action_pressed("ui_up")
	down_input= Input.is_action_pressed("ui_down")
	left_input = Input.is_action_pressed("ui_left")
	right_input = Input.is_action_pressed("ui_right")
	# ON / OFF Inputs
	run_input_press = Input.is_action_just_pressed("run")
	run_input_releas = Input.is_action_just_released("run")
	crouch_input_press = Input.is_action_just_pressed("crouch")
	crouch_input_releas = Input.is_action_just_released("crouch")
	## -------------------------------------------

	velocity = Vector2()
	if up_input:
		velocity += Vector2(0, -1)
	if down_input:
		velocity += Vector2(0, 1)
	if left_input:
		velocity += Vector2(-1, 0)
	if right_input:
		velocity += Vector2(1, 0)

	
	if is_running:
		velocity = velocity.normalized() * run_speed
	elif is_crouching:
		velocity = velocity.normalized() * crouch_speed
	else:
		velocity = velocity.normalized() * walk_speed


func stamina_decrease():
	stamina -= 1
	

func stamina_increase():
	stamina += 1


func _physics_process(delta: float):
	get_motion_input(delta)
	state_machine(delta)
	look_at(get_global_mouse_position())
	velocity = move_and_slide(velocity)