extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var id
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	print(id)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_button_pressed():
	id = $MarginContainer2/HBoxContainer/VBoxContainer2/Filename.get_text()
	Global.load_path = String("res://Save/" + id)
#	print(Global.load_path)
	Save_Game.load_game()
	Global.load_game = true
	Global.setScene(Global.load_scene)
	Global.game_loaded = true
	ImportData.inven_data = Global.dict_player_inventory
	ImportData.shop_inven = Global.dict_shop_inventory
	ImportData.enemy_stats = Global.dict_enemy_stats
	ImportData.character_stats = Global.dict_character_stats
	ImportData.formation_data = Global.dict_formation_stats
	ImportData.quest_stats = Global.dict_quest_stats
	ImportData.options_stats = Global.dict_options_stats
	ImportData.update_key_bindings()


func _on_Delete_File_pressed():
	id = $MarginContainer2/HBoxContainer/VBoxContainer2/Filename.get_text()
	Global.load_path = String("res://Save/" + id)
#	print(Global.load_path)
	var dir = Directory.new()
	dir.remove(Global.load_path)
	Global.setScene("res://Scenes/LoadGame.tscn")

