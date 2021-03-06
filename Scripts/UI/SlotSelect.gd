extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal exit
signal selected(slot_name)
onready var blankbutton : PackedScene = load("res://Scenes/Buttons/Menu_Button_Tempate.tscn")

var slot_array = [1, 2, 3, 4]
var slot_name
# Called when the node enters the scene tree for the first time.
func _ready():
	for n in range(slot_array.size()):
		slot_name = slot_array[n]
		var newscene = blankbutton.instance()
		$DropPanelContainer/MainNodes/VBoxContainer.add_child(newscene)
		newscene.get_node("Label").set_text("slot " + str(slot_name))
#		newscene.connect("char_selected", self, "_on_char_selected")
		slot_name = newscene.get_node("Label").get_text()
		newscene.get_node(".").set_name("Slot" + str(n + 1))
	get_node("DropPanelContainer/MainNodes/VBoxContainer/Slot1/Button").grab_focus()
#func _process(delta):
#	pass


func _on_Close_button_up():
	get_node("../FullMenu").visible = true
	get_node("../FullMenu/TabsContainer/CategoryPanel/Weapons/Button").grab_focus()
	emit_signal("exit")
	queue_free()


func _on_char_selected(slot_name1):
	emit_signal("selected", slot_name1)
	_on_Close_button_up()
