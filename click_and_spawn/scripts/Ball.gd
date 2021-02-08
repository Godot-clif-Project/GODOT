extends RigidBody2D

onready var ball_sprite: Sprite = $Sprite
onready var destroy_timer: Timer = $DestroyTimer
onready var destroy_timer_label: Label = $DestroyTimerLabel
var rnd = RandomNumberGenerator.new()


func _ready():
	destroy_timer.start(10)


func _process(delta):
	destroy_timer_label.text = str(int(destroy_timer.time_left))


func _init():
	rnd.randomize()
	var r_velocity = Vector2((rnd.randf_range(-350, 350)), 
							 (rnd.randf_range(-350, 350)))
	var r_float = rnd.randf_range(10, 20)

	self.apply_impulse(r_velocity, r_velocity)
	self.gravity_scale = r_float
	self.mass = r_float
	self.physics_material_override.bounce = 0.5


# if collision shape is "pickable"
# it's detect mouse events
func _on_Ball_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if Input.is_mouse_button_pressed(BUTTON_RIGHT):
			self.queue_free()


func _on_DestroyTimer_timeout():
	self.queue_free()
