extends StateMachine


func _ready() -> void:
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("double_jump")
	add_state("fall")
	add_state("dash")
	call_deferred("set_state", states.idle)


func _state_logic(_delta):
	pass


func _get_transition(_delta):
	match state:
		states.idle:
			if not parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x != 0.0 and parent._get_move_input():
				return states.run
		states.run:
			if not parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif not parent._get_move_input():
				return states.idle
		states.jump:
			if parent.is_on_floor():
				return states.idle
			elif parent.current_jump_count == 0:
				return states.double_jump
			elif parent.velocity.y >= 0:
				return states.fall
			elif parent.is_dashing:
				return states.dash
		states.double_jump:
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y >= 0:
				return states.fall
			elif parent.is_dashing:
				return states.dash
		states.fall:
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y < 0:
				return states.jump
			elif parent.is_dashing:
				return states.dash
		states.dash:
			if parent.current_jump_count == 0 and not parent.is_dashing and parent.velocity.y < 0:
				return states.double_jump
			elif parent.velocity.y > 0:
				return states.fall
			elif parent.velocity.x != 0.0 and parent._get_move_input() and parent.is_on_floor():
				return states.run

	return null


func _enter_state(_new_state, _old_state):
	match _new_state:
		states.idle:
			parent.state_label.text = "idle"
		states.run:
			parent.state_label.text = "run"
		states.jump:
			parent.state_label.text = "jump"
		states.double_jump:
			parent.state_label.text = "double jump"
			parent._set_max_gravity(parent.double_jump_gravity)
		states.fall:
			parent.state_label.text = "fall"
		states.dash:
			parent.state_label.text = "dash"


func _exit_state(_old_state, _new_state):
	match _old_state:
		states.idle:
			pass
		states.run:
			pass
		states.jump:
			pass
		states.double_jump:
			pass
		states.fall:
			parent._set_max_gravity(parent.default_gravity)
		states.dash:
			pass
