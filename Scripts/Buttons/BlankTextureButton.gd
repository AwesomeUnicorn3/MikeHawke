extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal char_selected(char_name)
var char_name
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_button_up():
	char_name = $Label.get_text()
	emit_signal("char_selected", char_name)
