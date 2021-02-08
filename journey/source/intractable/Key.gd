extends Area2D

signal unlock_the_door()

func _on_Key_body_entered(body: Node) -> void:
	if body.name == "Player":
		get_parent().key_picked_up = true
		self.emit_signal("unlock_the_door")
		$AnimationPlayer.play("pickup")


func _on_KeyAnimationPlayer_animation_finished(_anim_name: String) -> void:
	self.queue_free()


func _enter_tree() -> void:
	var _con = self.connect("unlock_the_door", get_parent(), "_set_door_sprite")


func _ready() -> void:
	pass


func _exit_tree() -> void:
	print("{name} exited tree!".format({"name": self.name}))
	if self.is_connected("unlock_the_door", get_parent(), "_set_door_sprite"):
		self.disconnect("unlock_the_door", get_parent(), "_set_door_sprite")
