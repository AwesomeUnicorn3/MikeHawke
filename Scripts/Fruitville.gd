extends Control

onready var mike = get_node("main/Mike Hawke")

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.load_scene = self.filename
	mike.set_scene()

