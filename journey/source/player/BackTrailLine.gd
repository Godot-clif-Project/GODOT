extends Line2D

## -------------------------------------------------------------------------- ##
## VARIABLES
## -------------------------------------------------------------------------- ##

var lenght: float = 12.0
var point: Vector2 = Vector2.ZERO

## -------------------------------------------------------------------------- ##
## FUNCTIONS
## -------------------------------------------------------------------------- ##

func _physics_process(_delta: float) -> void:
	self.global_position = Vector2(0, 0)
	
	point = get_parent().global_position
	add_point(point)
	while get_point_count() > lenght:
		remove_point(0)
