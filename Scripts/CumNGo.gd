extends Node2D

onready var mike = get_node("main/Mike Hawke")
onready var mikeanim = get_node("main/Mike Hawke/anim")
# Called when the node enters the scene tree for the first time.
func _ready():
	set_scene()


func set_scene():
	if Global.load_game == true:
		Global.load_scene = self.filename
		mikeanim.play(Global.PlayerAnim)
		mike.set_global_position(Vector2(Global.PlayerX, Global.PlayerY))
		Global.load_game = false
	else:
		Global.load_scene = self.filename
		mikeanim.play(Global.PlayerAnim)
		mike.set_global_position(Vector2(Global.PlayerXTransfer, Global.PlayerYTransfer))
