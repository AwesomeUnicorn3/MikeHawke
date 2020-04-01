extends CanvasItem





func _on_TextureButton_button_up():
	SoundEffects.select()
	Save_Game.load_game()
	Global.setScene("res://Scenes/LoadGame.tscn")
