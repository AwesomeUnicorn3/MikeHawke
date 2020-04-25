extends TextureButton

onready var icon = $Key_Binding_VBox/Icon
onready var slot_key_label = $Key_Binding_VBox/Key
onready var slot_name_label = $Key_Binding_VBox/slot_name
onready var parent = get_node("../../../../../../..")
var parent_name
var slot_name 
var slot_key 
var icon_path
var lead_character

var dict_op = ImportData.options_stats
var dict_form = {}
var icon_name = ""
var inputaction
var character_name
var category
var options_name
var new = true
func _ready():
# warning-ignore:return_value_discarded
	if new == true:
		Global.connect("Refresh_GUI", self, "refresh")
		new = false

#get current quick access options from ImportData.options_stats dictionary
 #does not change

	dict_form = ImportData.formation_stats
	parent_name = Global.equip_menu_type
	for n in range(dict_form.size()):
		lead_character = dict_form.keys()[n]
		var lead_char_letter = int(dict_form[lead_character]["FormationNumber"]) #formation number
		if lead_char_letter == 1:
			break
	match parent_name:
		"EquipMenu":
			slot_name = parent.slot_name
			options_name = lead_character + " " + slot_name
			slot_key = String(dict_op[options_name]["Key1"]) 
			slot_key_label.set_text(slot_key)
			icon_name = dict_op[options_name]["equipped_item"]
			icon_path = "res://Icons/" + icon_name + ".png"
			icon.set_texture(load(icon_path))

		"GUI":
			slot_name = $Key_Binding_VBox/slot_name.get_text()
			options_name = lead_character + " " + slot_name
			icon_name = dict_op[options_name]["equipped_item"]
			icon_path = "res://Icons/" + icon_name + ".png"
			icon.set_texture(load(icon_path))
			inputaction =  String(dict_op[options_name]["Input_action"])
			slot_key = String(dict_op[options_name]["Key1"]) 
			slot_key_label.set_text(slot_key)



func refresh():
	_ready()



func _on_Key_Binding_slot_template_button_down():
	set_modulate(Color(0,0,0,0.3))
	
	match parent_name:
		"EquipMenu":
			parent._on_button_down(slot_name, options_name)
		"GUI":
			Input.action_press(inputaction)

func _on_Key_Binding_slot_template_button_up():
	set_modulate(Color(1,1,1,1))
	match parent_name:
		"EquipMenu":
			pass
		"GUI":
			Input.action_release(inputaction)
