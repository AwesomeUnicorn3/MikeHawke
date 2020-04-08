extends CanvasItem



func _on_TextureButton_button_up():
	$TextureButton.disabled = true
	SoundEffects.play_sfx(SoundEffects.Select, 1)
	Save_Game.save_game()
	var text1 = $Label.get_text()
	var id = String(Global.save_id)
	var save_text = String("File ") + id + text1
	$Label.set_text(save_text)
	$Label.visible = true
	
	var t = Timer.new()
	t.set_one_shot(true)
	self.add_child(t)
	t.set_wait_time(2)
	t.start()
	yield(t, "timeout")
	
	$Label.visible = false
	$Label.set_text(" Save Complete")
	$TextureButton.disabled = false
	t.queue_free()
