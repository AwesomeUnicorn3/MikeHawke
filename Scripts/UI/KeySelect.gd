extends Control

signal exit
signal accept

onready var key_container = $DropPanelContainer/MainNodes/Label3

var dict_formation = ImportData.formation_stats
var dict_options = ImportData.options_stats

var char_name
var lead_char_name
var lead_char_letter
var key
var key_object
var key_select_action_string
var key_number
var key_scancode
var action_control

func _ready():
	#find lead character (formation number 1)
	for n in range(dict_formation.size()):
		lead_char_name = dict_formation.keys()[n]
		lead_char_letter = int(dict_formation[lead_char_name]["FormationNumber"]) #formation number
		if lead_char_letter == 1:
			break



	#set key number
func _input(event):
	#When an event happens if the event is an input event key and is pressed
	if event is InputEventKey and event.is_pressed() == true: 
		#set the label to display the recorded keypress
		key_scancode = event.get_scancode()
		key = OS.get_scancode_string(event.get_scancode_with_modifiers())
		key_object = event
		key_container.set_text(key)
	#check to make sure key is not used elsewhere
		var action_list = InputMap.get_actions()
		for i in action_list:
			if InputMap.action_has_event(i, key_object):
				#if already used  clear key and notify player
				var label = dict_options[i]["Input_action"]
				key_container.set_text("Key already in use by " + label + ". Please try again.")
				$DropPanelContainer/MainNodes/Buttons/Accept/Button.disabled = true
				break
			else:
				
				#if not, enable the Accept button
				$DropPanelContainer/MainNodes/Buttons/Accept/Button.disabled = false




func _on_Accept_button_up():

	#Remove current key binding from action_list
# warning-ignore:unused_variable
	for i in range(0,InputMap.get_action_list(key_select_action_string).size()):
		if InputMap.get_action_list(key_select_action_string).size() > 0:
			var t = InputMap.get_action_list(key_select_action_string).size()
			InputMap.action_erase_event(key_select_action_string, InputMap.get_action_list(key_select_action_string)[t - 1])

	#add event key binding to the action_list
	var cat = dict_options[key_select_action_string]["Category"]
	match cat:
		"PlaceHolder":
			var input_action = dict_options[key_select_action_string]["Input_action"]
			var char_action_string = lead_char_name + " " + input_action
			dict_options[char_action_string]["Key1"] = key
			dict_options[char_action_string]["Key1Scancode"] = key_scancode
			InputMap.action_add_event(key_select_action_string, key_object)

		"Controls":
			var h = dict_options[key_select_action_string]["Key2Scancode"]
			if h == null:
				InputMap.action_add_event(key_select_action_string, key_object)
				dict_options[key_select_action_string]["Key1"] = key
				dict_options[key_select_action_string]["Key1Scancode"] = key_scancode
			else:
				dict_options[key_select_action_string]["Key" + key_number] = key
				dict_options[key_select_action_string]["Key" + key_number + "Scancode"] = key_scancode
				var id1 = " " + String(dict_options[key_select_action_string]["Key1Scancode"])
				var id2 = " " + String(dict_options[key_select_action_string]["Key2Scancode"])
				id1 = int(id1)
				id2 = int(id2)

			#send update to options table with current key value
			#if action_event is weapons, defense, slot1, slot2, slot3, or slo4
			#update options table lead character plus slot name for key1 or key2
			#otherwise update options table with event_action for key1 or key2
				var key1 = InputEventKey.new()
				var k1_KEY = OS.get_scancode_string(id1)
				key1.set_scancode(id1)
				InputMap.action_add_event(key_select_action_string, key1)
				dict_options[key_select_action_string]["Key1"] = k1_KEY
				dict_options[key_select_action_string]["key1Scancode"] = id1

				var key2 = InputEventKey.new()
				var k2_KEY = OS.get_scancode_string(id2)
				key2.set_scancode(id2)
				InputMap.action_add_event(key_select_action_string, key2)
				dict_options[key_select_action_string]["Key2"] = k2_KEY
				dict_options[key_select_action_string]["key2Scancode"] = id2


	
	emit_signal("accept", key)
	_on_CloseButton_button_up()


func _on_CloseButton_button_up():
	#send the exit signal to the action keys button
	emit_signal("exit")
	queue_free()
