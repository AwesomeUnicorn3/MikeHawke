extends CanvasItem


onready var menu: PackedScene = load("res://Scenes/UI/SkillMenu.tscn")
onready var scene_tree: = get_tree()
onready var sub_menu: MarginContainer = get_node("../../../SubMenu1")
var show =  false setget set_show_menu
var Temp 

func set_show_menu(value: bool) -> void:
	show = value
	if value == true:
		sub_menu.visible = true
		var scene_instance = menu.instance()
		sub_menu.add_child(scene_instance)
		Temp = scene_instance
		yield(Temp, "menu_closed")
		sub_menu.visible = false
		show = false



func _on_TextureButton_button_up():
	SoundEffects.play_sfx(SoundEffects.Select , 1)
	set_show_menu(not show)
