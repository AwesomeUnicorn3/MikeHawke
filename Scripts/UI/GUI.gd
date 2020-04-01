extends Control

#onready var scene_tree: = get_tree()

onready var shop_menu: PackedScene = load("res://Scenes/UI/ShopProcessing.tscn")
onready var player = get_node("../../main/Mike Hawke")
var show_hide_gui = false setget hide_gui

# warning-ignore:unused_argument
#func _process(delta):
#	var fps = Engine.get_frames_per_second()
#	$TopRightGui/Label.set_text(str(fps))
func _ready():
	$TopRightGui/VBoxContainer/HealthBar.set_max(ImportData.character_stats[Global.PlayerName]["MaxHealth"])
	$TopRightGui/VBoxContainer/HealthBar.set_value(ImportData.character_stats[Global.PlayerName]["CurrentHealth"])
	player.connect("Health_Change", self, "_on_health_change")
	
func hide_gui(value: bool) -> void:
	show_hide_gui = value
	self.visible = not value
	Global.gui = value


func _on_health_change():
	$TopRightGui/VBoxContainer/HealthBar.set_value(ImportData.character_stats[Global.PlayerName]["CurrentHealth"])



#func _on_ShopTest_button_up():
#	Global.shop_name = "Frank's Sundries"
#	var scene_instance = shop_menu.instance()
#	$".".add_child(scene_instance)
##	Global.shop_name = "Frank's Sundries"

