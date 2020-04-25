extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal exit
signal selected(char_name)
onready var blankbutton : PackedScene = load("res://Scenes/UI/BlankTextureButton.tscn")
var dict_formation = ImportData.formation_stats
var dict_items = ImportData.item_data
var dict_char = ImportData.character_stats

var char_name

func _ready():
	for n in range(dict_formation.size()):
		char_name = dict_formation.keys()[n]
		var _char_form_num = int(dict_formation[char_name]["FormationNumber"])
		var char_in_party = dict_formation[char_name]["InParty"]
		if char_in_party == "Yes":
			var newscene = blankbutton.instance()
			$DropPanelContainer/MainNodes/VBoxContainer.add_child(newscene)
			newscene.get_node("Label").set_text(char_name)
			newscene.connect("char_selected", self, "_on_char_selected")


func _on_CloseButton_button_up():
	emit_signal("exit")
	self.queue_free()


func _on_char_selected(char_name1):
	emit_signal("selected", char_name1)
	_on_CloseButton_button_up()
