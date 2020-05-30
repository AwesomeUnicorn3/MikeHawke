extends Node2D

export (Texture) var face

export (Color) var color # COLOR OF THE TEXT

export (float, 0.1, 1.9) var voice_pitch # HOW HIGH / LOW THE VOICE IS

export (String, FILE) var interaction_script # A JSON DIALOGUE FILE

onready var mike = get_node("main/Mike Hawke")
onready var gui: Control = get_node("CanvasLayer/GUI")
export var Mikex = 0
export var Mikey = -62
export var CamZoom = Vector2(.4,.4)
# Called when the node enters the scene tree for the first time.
func _ready():
	mike.set_scene(CamZoom)
	Global.load_scene = self.filename

