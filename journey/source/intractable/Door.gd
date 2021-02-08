extends Area2D


export var next_level: String

onready var collision: CollisionShape2D = $BodyCollision


func _on_Door_body_entered(body: Node) -> void:
	if body.name == "Player" and owner.key_picked_up:
		collision.set_deferred("disabled", true)
		SceneTransition.change_scene(next_level)
	else:
		print("Door is Locked!")


func _ready() -> void:
	pass
