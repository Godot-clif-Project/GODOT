extends Node2D


onready var key_scene_path: PackedScene = load("res://source/intractable/Key.tscn")
onready var key_scene: Area2D = $Key
onready var key_position: Vector2 = $Key.position

onready var player_scene: KinematicBody2D = $Player
onready var door_scene: Area2D = $Door
onready var background: ColorRect = $Control/BackgroundColorRect
onready var wall_jump_tile: TileMap = $WallJumpTileMap
onready var wall_tile: TileMap = $WallTileMap

var door_close_sprite: Texture = preload("res://assets/door/door_close_01.png")
var door_open_sprite: Texture = preload("res://assets/door/door_open_01.png")

var key_picked_up: bool = false

var selected_random_color_palet: String

var color_palets: Dictionary = {
	"alternate_color": Color("#ffffff"),
	"red": {
		"player_color": Color("#FE4365"),
		"background_color": Color("#F9CDAD"),
		"wall_jump_tile_color": Color("#FC9D9A"),
		"wall_tile_color": Color("#83AF9B"),
		"interactable_color": Color("#83AF9B")
	},
	"green": {
		"player_color": Color("#F56991"),
		"background_color": Color("#FF9F80"),
		"wall_jump_tile_color": Color("#D1F2A5"),
		"wall_tile_color": Color("#FFC48C"),
		"interactable_color": Color("#EFFAB4")
	},
	"blue": {
		"player_color": Color("#D1E751"),
		"background_color": Color("#4DBCE9"),
		"wall_jump_tile_color": Color("#FFFFFF"),
		"wall_tile_color": Color("#26ADE4"),
		"interactable_color": Color("#4DBCE9")
	},
	"gray": {
		"player_color": Color("#00dffc"),
		"background_color": Color("#343838"),
		"wall_jump_tile_color": Color("#005F6B"),
		"wall_tile_color": Color("#008C9E"),
		"interactable_color": Color("#00b4cc")
	}
}


func _on_DeadArea_body_entered(body: Node) -> void:
	if body.name == "Player":
		body.call_deferred("dead")
		if key_picked_up:
			key_picked_up = false
			yield(get_tree().create_timer(0.1), "timeout")
			var _key = key_scene_path.instance()
			self.add_child(_key)
			_key.get_node("KeySprite").set_modulate(color_palets[selected_random_color_palet].interactable_color)
			_key.position = key_position
			_set_door_sprite()


func _ready() -> void:
	selected_random_color_palet = pick_random_color_palet()
	level_color_setup()
	player_scene.set_physics_process(false)
	yield(get_tree().create_timer(0.5), "timeout")
	player_scene.set_physics_process(true)


func _set_door_sprite():
	if key_picked_up:
		door_scene.get_node("DoorSprite").set_texture(door_open_sprite)
	else:
		door_scene.get_node("DoorSprite").set_texture(door_close_sprite)


func pick_random_color_palet() -> String:
#	var selected_color = randi()%4+1
	var selected_color = 4
	match selected_color:
		1:
			return "red"
		2:
			return "blue"
		3: 
			return "green"
		4:
			return "gray"
	return selected_color


func level_color_setup():
	# Player Color
	player_scene.get_node("BodySprite").set_modulate(color_palets[selected_random_color_palet].player_color)
	player_scene.get_node("AnimationPlayer").get_animation("spawn").track_set_key_value(0, 0, color_palets.alternate_color)
	player_scene.get_node("AnimationPlayer").get_animation("spawn").track_set_key_value(0, 1, color_palets[selected_random_color_palet].player_color)
	player_scene.get_node("AnimationPlayer").get_animation("spawn").track_set_key_value(0, 2, color_palets.alternate_color)
	player_scene.get_node("AnimationPlayer").get_animation("spawn").track_set_key_value(0, 3, color_palets[selected_random_color_palet].player_color)
	# Player Tail Color
	player_scene.get_node("BodySprite").get_node("BackTrailLine").gradient.colors[1] = color_palets[selected_random_color_palet].player_color
	# Environment Color
	background.color = color_palets[selected_random_color_palet].background_color
	wall_jump_tile.set_modulate(color_palets[selected_random_color_palet].wall_jump_tile_color)
	wall_tile.set_modulate(color_palets[selected_random_color_palet].wall_tile_color)
	# Interactable Color
	key_scene.get_node("KeySprite").set_modulate(color_palets[selected_random_color_palet].interactable_color)
	key_scene.get_node("AnimationPlayer").get_animation("pickup").track_set_key_value(1, 0, color_palets[selected_random_color_palet].interactable_color)	
	door_scene.get_node("DoorSprite").set_modulate(color_palets[selected_random_color_palet].interactable_color)


func _exit_tree() -> void:
	print("{name} exited tree!".format({"name": self.name}))
	self.queue_free()
