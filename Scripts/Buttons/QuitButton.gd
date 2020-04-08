extends CanvasItem


func _on_TextureButton_button_up():
	SoundEffects.play_sfx(SoundEffects.Select , 1)
	get_tree().paused = false
	get_node("/root/Global").setScene("res://Scenes/TitleScreen.tscn")
