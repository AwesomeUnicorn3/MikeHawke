extends CanvasItem


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var scene_tree: = get_tree()
onready var main_menu: Control = get_node("../../MainMenu")

var paused =  false setget set_paused
# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _unhandled_key_input(event):

	if event.is_action_pressed("pause") or event.is_action_pressed("ui_menu"):
		paused = true
		scene_tree.set_input_as_handled()
		set_paused(paused)

func set_paused(value: bool) -> void:
	paused = value
	scene_tree.paused = value
	self.visible = not value
	main_menu.visible = value







func _on_TextureButton_button_up():
	paused = true
	SoundEffects.play_sfx(SoundEffects.Select , 1)
	set_paused(paused)
