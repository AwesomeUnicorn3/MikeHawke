extends VBoxContainer
onready var ItemInspector : PackedScene  = load("res://Scenes/UI/ItemDisplay.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	ItemInspector.connect( "get_item_info", self, "on_get_item_info")

