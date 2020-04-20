extends Node

signal Refresh_GUI
var save_id = 0
var save_path = ""
var load_path = ""
var new_game = true
var load_game = false
var game_loaded = false
var current_scene = null
var load_scene = "res://Scenes/IndoorMaps/House-Mike.tscn"
var ExpDrop = 0
var text = ""
#Player Position/Location
var PlayerName = "Mike Hawke"
var PlayerX = 0
var PlayerY = 0
var PlayerMap = "res://Scenes/IndoorMaps/House-Mike.tscn"
var PlayerXTransfer = 0
var PlayerYTransfer = 0
var PlayerAnim = "IdleDown"
var PlayerDir = "Down"
var PlayerSpriteDir = "Down"
var PlayerCanMove = false
var CanTalk = true
var CanInteract = false
var gui = false
var body
var shop_name
var buysell = ""
var equip_menu_type = "GUI"

#Options
var dict_options_stats = {}


#Inventory
var currency = "Chode"
#var Chode = 0
var dict_player_inventory = {}
var dict_shop_inventory = {}
var dict_enemy_stats = {}
var dict_character_stats = {}
var dict_formation_stats = {}
var dict_quest_stats = {}

#arrays
var array_save_id = [0]
var array_load_files = []
var array_misc_items = []



#Dictionaries
var Dict_locations = {
"res://Scenes/IndoorMaps/House-Mike.tscn" : "Mike's House",
"res://Scenes/Fruitville.tscn" : "Fruitville",
"res://Scenes/IndoorMaps/CumNGo.tscn" : "CumNGo",
"res://Scenes/IndoorMaps/FranksSundries.tscn": "Frank's Sundries"
}
var Dict_objects_fruitville = {}
var Dict_shizzo_cans = {}
var Dict_trash_cans = {}
var Dict_loot = {}
var Dict_signs = {}
var Dict_toilet = {}
var Dict_time = OS.get_datetime()
var Dict_static_time = {}
var save_dict = {}


#Functions
func _ready():
	current_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)
	
	
func setScene(scene):
	call_deferred("deferred_SetScene" , scene)
	
func deferred_SetScene(scene):
	current_scene.free()
	var s = ResourceLoader.load(scene)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	
func save_game():
	Dict_static_time = Dict_time

	add_to_group("save")

	
	save_dict = {
	PlayerAnim = PlayerAnim,
	dict_options_stats = ImportData.options_stats,
	dict_quest_stats = ImportData.quest_stats,
	dict_formation_stats = ImportData.formation_stats,
	dict_enemy_stats  = ImportData.enemy_stats,
	dict_player_inventory = ImportData.inven_data,
	dict_shop_inventory = ImportData.shop_inven,
	dict_character_stats = ImportData.character_stats,
	Dict_static_time = Dict_static_time,
	save_id = save_id,
	new_game = new_game,
	game_loaded = game_loaded,
	PlayerX = PlayerX,
	PlayerY = PlayerY,
	PlayerXTransfer = PlayerXTransfer,
	PlayerYTransfer = PlayerYTransfer,
	PlayerCanMove = PlayerCanMove,
	CanInteract = CanInteract,
	PlayerDir = PlayerDir,
	load_scene = load_scene,
	Dict_objects_fruitville = Dict_objects_fruitville,
	Dict_trash_cans = Dict_trash_cans,
	Dict_shizzo_cans = Dict_shizzo_cans,
	Dict_toilet = Dict_toilet,
	Dict_loot = Dict_loot,
	Dict_locations = Dict_locations
	}
	return save_dict
	
	
	
func can_talk():
	CanTalk = false
	
func Can_walk():
	PlayerCanMove = true
	
func Cant_walk():
	PlayerCanMove = false



func reload_Dict():
	Global.PlayerX = Global.PlayerXTransfer
	Global.PlayerY = Global.PlayerYTransfer
	Global.dict_player_inventory = ImportData.inven_data 
	Global.dict_shop_inventory = ImportData.shop_inven
	Global.dict_enemy_stats = ImportData.enemy_stats
	Global.dict_character_stats =ImportData.character_stats
	Global.dict_options_stats = ImportData.options_stats
	Save_Game.save_game()
	Global.load_path = String("res://Save/" + str(Global.save_id))
#	print(Global.load_path)
	Save_Game.load_game()
	Global.load_game = true
	Global.game_loaded = true
	ImportData.inven_data = Global.dict_player_inventory
	ImportData.shop_inven = Global.dict_shop_inventory
	ImportData.enemy_stats = Global.dict_enemy_stats
	ImportData.character_stats = Global.dict_character_stats
	Global.dict_options_stats = ImportData.options_stats



func refresh_gui():
	emit_signal("Refresh_GUI")
