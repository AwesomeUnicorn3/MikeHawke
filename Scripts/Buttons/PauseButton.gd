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
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		self.paused = not paused
		scene_tree.set_input_as_handled()

func set_paused(value: bool) -> void:
	paused = value
	scene_tree.paused = value
	self.visible = not value
	main_menu.visible = value







func _on_TextureButton_button_up():
	set_paused(true)
