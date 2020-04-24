extends TextureButton

onready var keyselect : PackedScene = load("res://Scenes/UI/KeySelect.tscn")
onready var parent = get_node("../../../../../../..")

var action_string_button
var action_control
var key_id 
func _ready():
	key_id = self.get_name()



func _on_button_down():
	set_modulate(Color(1,1,1,.5))


func _on_button_up():
	#when the button is pressed, darken the texture
	set_modulate(Color(1,1,1,1))
	#create a new keyselect node and connect the 'accept' and 'exit' signals
	var i = keyselect.instance()
	i.key_number = key_id
	i.connect("accept", self, "_on_accept")
	i.connect("exit", self, "_on_cancel")
	#set the action key text to keyselect label 2
	var action_key = get_node("../Action_Label").get_text()
	parent.action_string = action_string_button
	i.get_node("DropPanelContainer/MainNodes/Label2").set_text((action_key))
	i.key_select_action_string = action_control
	#Add the node to the 'parent'node and disable input for all button on the options menu
	parent.add_child(i)
	_on_disable_button(true)
#	yield(i, "exit")


func _on_accept(key):
	$Input_Label.set_text(key)
	_on_disable_button(false)


func _on_cancel():
	_on_disable_button(false)


func _on_disable_button(value: bool):
	#disable/enable using 'value' all action key buttons on the options menu
	var gui = parent.get_node("../../..")
	if value == true:
		gui.set_pause_mode(PAUSE_MODE_STOP)
	else:
		gui.set_pause_mode(PAUSE_MODE_PROCESS)


