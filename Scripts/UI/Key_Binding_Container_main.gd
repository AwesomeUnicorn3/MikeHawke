extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.equip_menu_type = "GUI"
# warning-ignore:return_value_discarded
	Global.connect("Refresh_GUI", self, "refresh")


func refresh():
	for i in $HBoxContainer.get_child_count():
		$HBoxContainer.get_child(i)._ready()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
