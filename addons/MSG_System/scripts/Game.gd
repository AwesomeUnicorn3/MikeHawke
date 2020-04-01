
extends Node


var player_name = "Player"

var talked_to_mark = false
var talked_to_jane = false
var talked_to_sam = false

var wins = 0


func player():
	return MSG.level_root().get_node("main/Mike Hawke")
	

func can_talk(b):
#	get_node("/root/Fruitville/buttons").visible = b
	Global.CanTalk = b

#func show_fireworks():
#	MSG.level_root().get_node("fireworks").emitting = true
#	yield(MSG.time(2), "timeout")
#	MSG.level_root().get_node("fireworks").emitting = false


	
