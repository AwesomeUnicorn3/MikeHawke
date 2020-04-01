extends CanvasItem


func _on_TextureButton_button_up():
	SoundEffects.select()
	get_tree().paused = false
	get_node("/root/Global").setScene("res://Scenes/TitleScreen.tscn")
