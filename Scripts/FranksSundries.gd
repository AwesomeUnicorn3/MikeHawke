extends Node2D

onready var mike = get_node("main/Mike Hawke")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	mike.set_scene()


