extends Sprite
export var talk_to = ""
export (Texture) var face

export (Color) var color # COLOR OF THE TEXT

export (float, 0.1, 1.9) var voice_pitch # HOW HIGH / LOW THE VOICE IS

export (String, FILE) var interaction_script # A JSON DIALOGUE FILE
var id
var selected = false
var stop = false


func talk():
	Global.PlayerCanMove = false
#	print("talking to " + self.name)
	MSG.start_dialogue(interaction_script, self)
	Global.PlayerCanMove = MSG.var("CanMove")
	


func _process(delta):
	if $button.visible == true:
		if selected == true:
			talk()


func _on_Area2D_body_entered(body):
	$button.visible = true




func _on_Area2D_body_exited(body):
	$button.visible = false
	Global.CanTalk = true

func _input(event):
	if Input.is_action_pressed("ui_accept"):
		selected = true

#		print(selected)
	if Input.is_action_just_released("ui_accept"):
		selected = false
#		print(selected)
		
