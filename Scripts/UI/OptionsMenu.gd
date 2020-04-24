extends Control
signal menu_closed

onready var action_names : PackedScene = load("res://Scenes/UI/Action_Names.tscn")

onready var Controls_vbox = $FullMenu/TabsContainer/Controls/VBoxContainer


var dict_formation = ImportData.formation_stats
var dict_char = ImportData.character_stats
var dict_inven = ImportData.inven_data
var dict_item = ImportData.item_data
var dict_options = ImportData.options_stats

var lead_char_name
var lead_char_letter
var action_string

func _ready():
	pass



func _control_display_action_list():
	#find lead character from formation table
	for n in range(dict_formation.size()):
		lead_char_name = dict_formation.keys()[n]
		lead_char_letter = int(dict_formation[lead_char_name]["FormationNumber"]) #formation number
		if lead_char_letter == 1:
			break
	#update lead char label with lead character name
	$FullMenu/Header/Lead_Char.set_text(lead_char_name)
	#update weapon, defense, and slot actions with lead character data from options table
	var action_list = InputMap.get_actions()
	var key
	for i in action_list:
		var ui = action_names.instance()
		var count = 1
		for action in InputMap.get_action_list(i):
			if action is InputEventKey:
				var action_label = dict_options[i]["Input_action"]
				if dict_options[i]["Key1"] != "":
					action_string = i
				else:
					var inp_action = dict_options[i]["Input_action"]
					action_string = dict_options[lead_char_name + " " + inp_action]["Input_action"]
				ui.get_node("Control/Action_Label").set_text(action_label)
				key = OS.get_scancode_string(action.scancode)
				ui.get_node("Control/" + str(count) + "/Input_Label").set_text(str(key))
				ui.get_node("Control/" + str(count)).action_control = action_string
				
				if count == 1:
					action_string = i
					ui.get_node("Control/" + str(count)).action_string_button = action_string
					Controls_vbox.add_child(ui)
					ui.action_string_button = action_string
					count += 1
				else:
					action_string = i
					ui.get_node("Control/" + str(count)).action_string_button = action_string
					ui.get_node("Control/" + str(count)).visible = true
					count += 1





#func clear_item_detail():
#	item_name_container.set_text("")
#	item_Description_container.set_text("")
#	var parent = item_detail_container
#	if parent != null:
#		for n in parent.get_children():
#			parent.remove_child(n)

func _on_Controls_button_up():
	_control_display_action_list()
#	close_all_tabs()
#	clear_item_detail()


func _on_ExitButton_button_up():
	Save_Game.save_game()
	emit_signal("menu_closed")
	queue_free()
