extends Control

signal detail

func _ready():
	pass # Replace with function body.



func _on_QuestName2_button_up():
	var id = self.name
	emit_signal("detail", id)


func _on_QuestName2_focus_entered():
	$AnimationPlayer.play("Selected")


func _on_QuestName2_mouse_entered():
	_on_QuestName2_focus_entered()


func _on_QuestName2_focus_exited():
	$AnimationPlayer.stop()
	$ColorRect.color = Color(0,0,0, .45)


func _on_QuestName2_mouse_exited():
	_on_QuestName2_focus_exited()
