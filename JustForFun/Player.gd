extends KinematicBody2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var character_name: String = "Dolly"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(character_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
