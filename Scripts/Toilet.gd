extends Sprite


export (Texture) var face
export (Color) var color # COLOR OF THE TEXT
export (float, 0.1, 1.9) var voice_pitch # HOW HIGH / LOW THE VOICE IS
export (String, FILE) var interaction_script # A JSON DIALOGUE FILE
var id
var selected = false
var talking = false

func _ready():
	id = self.get_name()
	if Global.Dict_toilet.has(id) == false:
		Global.Dict_toilet[id] = true
	if Global.Dict_toilet[id] == true:
		$Sprite3.visible = false
		$Sprite2.visible = true
	else:
		$Sprite3.visible = true
		$Sprite2.visible = false
		
func talk():
	if Global.CanInteract == false:
		pass
	else:
		talking = true
		Global.PlayerCanMove = false
		MSG.start_dialogue(interaction_script, self)
		flush_toilet()
		

	
	
func _input(event):
	if Input.is_action_pressed("ui_accept"):
		selected = true
#		print(selected)
	else:
		selected = false
#	if Input.is_action_just_released("ui_accept"):
#		selected = false
#		print(selected)

func _process(delta):
	if $TouchScreenButton.visible == true:
		if selected == true:
			if talking == true:
				pass
			else:
				talk()


func _on_Area2D_body_entered(body):
	$TouchScreenButton.visible = true


func _on_Area2D_body_exited(body):
	$TouchScreenButton.visible = false
	Global.CanTalk = true
	talking = false


func flush_toilet():
	SoundEffects.Flush()
	$Sprite3.visible = true
	$Sprite2.visible = false
	Global.Dict_toilet[id] = false
