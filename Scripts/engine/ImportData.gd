extends Node

var importtext = false
#Static dictionaries
var formation_data = {} #Static Formation Table 
var loot_data = {}     #Static loot table (which map you can loot which items) information from json
var shop_data = {}     #Static Shop information from json
var item_data = {}     #Static item information from json
var enemy_data = {}   #Static enemy stats
var character_data = {} #Static Character stats
var level_data = {}    #Static Level data (how much exp to next level and Atk, Def Modifiers for each level)
var quest_data = {}    #Static Quest data
var options_data = {}	#Static Options data
var dialogue_data = {}  #Static dialogue data
var location_data = {}  #Static Location data
#Dynamic Dictionaries 
var formation_stats = {} #Same as Global.dict_formation_stats
var enemy_stats = {}   #Same as Global.dict_enemy_stats 
var inven_data = {}  #Same as Global.dict_player_inventory - Should only have chode when starting a new game - has no direct import file
var shop_inven = {} #Same as Global.dict_shop_inventory (keeps track of the count of any items that are limited in the shops)
var character_stats = {} #Same as Global.dict_character_stats
var quest_stats = {}  #Same as Global.dict_quest_stats
var options_stats = {} #Same as Global.dct_options_stats

func _ready():
	inven_data.clear()
	Global.dict_player_inventory.clear()
	inven_data = {"Chode":["Chode",0]}
	Global.dict_player_inventory = inven_data
	
	var itemdata_file = File.new()
	itemdata_file.open("res://Data/ItemTable - Sheet1.json", File.READ)
	var itemdata_json = JSON.parse(itemdata_file.get_as_text())
	itemdata_file.close()
	item_data = itemdata_json.result

	var locationdata_file = File.new()
	locationdata_file.open("res://Data/LocationData - Sheet1.json", File.READ)
	var locationdata_json = JSON.parse(locationdata_file.get_as_text())
	locationdata_file.close()
	location_data = locationdata_json.result

	var dialoguedata_file = File.new()
	dialoguedata_file.open("res://Data/DialogueTable - Sheet1.json", File.READ)
	var dialoguedata_json = JSON.parse(dialoguedata_file.get_as_text())
	dialoguedata_file.close()
	dialogue_data = dialoguedata_json.result
	
	var leveldata_file = File.new()
	leveldata_file.open("res://Data/LevelData - Sheet1.json", File.READ)
	var leveldata_json = JSON.parse(leveldata_file.get_as_text())
	leveldata_file.close()
	level_data = leveldata_json.result
	
	var lootdata_file = File.new()
	lootdata_file.open("res://Data/LootTable - Sheet1.json", File.READ)
	var lootdata_json = JSON.parse(lootdata_file.get_as_text())
	lootdata_file.close()
	loot_data = lootdata_json.result


	var shopdata_file = File.new()
	shopdata_file.open("res://Data/ShopTable - Sheet1.json", File.READ)
	var shopdata_json = JSON.parse(shopdata_file.get_as_text())
	shopdata_file.close()
	shop_data = shopdata_json.result
	shop_inven = shop_data

	var enemydata_file = File.new()
	enemydata_file.open("res://Data/EnemyStats - Sheet1.json", File.READ)
	var enemydata_json = JSON.parse(enemydata_file.get_as_text())
	enemydata_file.close()
	enemy_data = enemydata_json.result
	enemy_stats = enemy_data
	
	
	var questdata_file = File.new()
	questdata_file.open("res://Data/QuestTable - Sheet1.json", File.READ)
	var questdata_json = JSON.parse(questdata_file.get_as_text())
	questdata_file.close()
	quest_data = questdata_json.result
	quest_stats = quest_data
	
	var characterdata_file = File.new()
	characterdata_file.open("res://Data/CharacterStats - Sheet1.json", File.READ)
	var characterdata_json = JSON.parse(characterdata_file.get_as_text())
	characterdata_file.close()
	character_data = characterdata_json.result
	character_stats = character_data

	var formationdata_file = File.new()
	formationdata_file.open("res://Data/FormationTable - Sheet1.json", File.READ)
	var formationdata_json = JSON.parse(formationdata_file.get_as_text())
	formationdata_file.close()
	formation_data = formationdata_json.result
	formation_stats = formation_data

	var optionsdata_file = File.new()
	optionsdata_file.open("res://Data/OptionsTable - Sheet1.json", File.READ)
	var optionsdata_json = JSON.parse(optionsdata_file.get_as_text())
	optionsdata_file.close()
	options_data = optionsdata_json.result
	options_stats = options_data

func update_key_bindings():
	var lead_char_name
	var lead_char_letter
	#set all of the action key bindings from the options#
	# first remove all previous keys bound to each action
		#loop through all actions in the action list
	for h in InputMap.get_actions():
	#	#for each action, loop through key binds
		for j in InputMap.get_action_list(h):
#			#remove each key bind
			if j == InputEventKey:
				InputMap.action_erase_event(h, j)

	#find the lead character
	for n in range(formation_stats.size()):
		lead_char_name = formation_stats.keys()[n]
		lead_char_letter = int(formation_stats[lead_char_name]["FormationNumber"]) #formation number
		if lead_char_letter == 1:
			break
	#loop through all of the actions in the action list again
	for h in InputMap.get_actions():
	#for each action, if keyscancode from options table == null
	#add each key from the options table

		if (options_stats.keys()).has(h):
			var cat = options_stats[h]["Category"]
			match cat: 
				"PlaceHolder":
					var input_action = options_stats[h]["Input_action"]
					var char_action_string = lead_char_name + " " + input_action
					var key1 = options_stats[char_action_string]["Key1Scancode"]
					var key1object = InputEventKey.new()
					key1object.set_scancode(key1)
					InputMap.action_add_event(h, key1object)
				
				"Controls":
					var key1 = options_stats[h]["Key1Scancode"]
					var key2 = options_stats[h]["Key2Scancode"]
					var key1object = InputEventKey.new()
					key1object.set_scancode(key1)
					InputMap.action_add_event(h, key1object)
					if key2 != null:
						var key2object = InputEventKey.new()
						key2object.set_scancode(key2)
						InputMap.action_add_event(h, key2object)
