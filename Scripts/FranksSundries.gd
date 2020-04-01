extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_scene()


func set_scene():
	if Global.load_game == true:
		Global.load_scene = self.filename
		get_node("main/Mike Hawke/anim").play(Global.PlayerAnim)
		$"main/Mike Hawke".set_global_position(Vector2(Global.PlayerX, Global.PlayerY))
		Global.load_game = false
	else:
		Global.load_scene = self.filename
		get_node("main/Mike Hawke/anim").play(Global.PlayerAnim)
		$"main/Mike Hawke".set_global_position(Vector2(Global.PlayerXTransfer, Global.PlayerYTransfer))
