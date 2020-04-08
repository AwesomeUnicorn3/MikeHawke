extends CanvasItem





func _on_TextureButton_button_up():
	SoundEffects.play_sfx(SoundEffects.Select ,1)
	Save_Game.load_game()
	Global.setScene("res://Scenes/LoadGame.tscn")
