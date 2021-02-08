extends CanvasLayer


signal scene_changed()

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var control: Control = $Control
onready var color: ColorRect = $Control/Color


func _enter_tree() -> void:
	print("{name} entered tree!".format({"name": self.name}))


func _ready() -> void:
	_set_visibility(false)


func _set_visibility(value) -> void:
	control.visible = value


func change_scene(path, delay: float = 0.5) -> void:
	_set_visibility(true)
	yield(get_tree().create_timer(delay), "timeout")
	animation_player.play_backwards("transition")
	yield(animation_player, "animation_finished")
	assert(get_tree().change_scene(path) == OK)
	animation_player.play("transition")
	yield(animation_player, "animation_finished")
	emit_signal("scene_changed")


func _exit_tree() -> void:
	print("{name} exited tree!".format({"name": self.name}))
