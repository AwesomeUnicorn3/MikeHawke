extends CanvasItem





func _on_TextureRect_button_up():
	SoundEffects.select()

	Save_Game.new_game()
	Save_Game.save_game()
	get_node("/root/Global").setScene("res://Scenes/IndoorMaps/House-Mike.tscn")
