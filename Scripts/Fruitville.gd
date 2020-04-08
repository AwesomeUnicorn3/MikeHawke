extends Node2D

onready var mike = get_node("main/Mike Hawke")
onready var mikeanim = get_node("main/Mike Hawke/AnimationPlayer")
# Called when the node enters the scene tree for the first time.
func _ready():
	mike.set_scene()

#
#func set_scene():
#	var mikeanim = MSG.level_root().get_node("main/Mike Hawke/AnimationTree")
#	var animationState = mikeanim.get("parameters/playback")
#	if Global.load_game == true:
#		Global.load_scene = self.filename
#		print(filename)
##		mikeanim.play(Global.PlayerAnim)
#		mike.set_global_position(Vector2(Global.PlayerX, Global.PlayerY))
#		mike.AnimationTree.active = true
#		animationState.start("Idle")
#		Global.load_game = false
#	else:
#		Global.load_scene = self.filename
##		mikeanim.play(Global.PlayerAnim)
#		mike.set_global_position(Vector2(Global.PlayerXTransfer, Global.PlayerYTransfer))
#		mikeanim.active = true
#		animationState.start("Idle")
