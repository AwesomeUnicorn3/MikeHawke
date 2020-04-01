extends Container

signal detail

func _ready():
	pass # Replace with function body.



func _on_QuestName2_button_up():
	var id = self.name
	emit_signal("detail", id)
