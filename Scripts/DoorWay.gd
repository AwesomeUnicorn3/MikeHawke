tool

extends Node2D


export(String, FILE ) var Goto_scene = ""
export var set_player_position = Vector2()

# warning-ignore:unused_argument
func _on_Area2D_body_entered(body):
	#figure out a better way to transfer scenes (use a node to set mike position)
	Global.setScene(Goto_scene)
	Global.PlayerXTransfer = set_player_position.x
	Global.PlayerYTransfer = set_player_position.y
	Global.load_scene = Goto_scene


func _get_configuration_warning() -> String:
	
	if Goto_scene == "":
		return "Set Goto Scene path"
	else:
		return ""

