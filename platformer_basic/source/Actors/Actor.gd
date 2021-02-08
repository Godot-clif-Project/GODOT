extends KinematicBody2D

class_name Actor # Class

const FLOOR_NORMAL: Vector2 = Vector2.UP

export var gravity: float
export var speed: Vector2

var _velocity: Vector2 = Vector2.ZERO

