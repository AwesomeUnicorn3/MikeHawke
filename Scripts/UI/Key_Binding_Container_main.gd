extends Control



func _ready():
	Global.equip_menu_type = "GUI"
# warning-ignore:return_value_discarded
	Global.connect("Refresh_GUI", self, "refresh")


func refresh():
	for i in $HBoxContainer.get_child_count():
		$HBoxContainer.get_child(i)._ready()

