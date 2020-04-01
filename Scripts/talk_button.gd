extends Node

#export var talk_to = ""

func _ready():

	connect("pressed", self, "on_pressed")

func on_pressed():
	if get_node("..").talking == true:
		pass
	else:
		get_node("..").talk()
