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
var dialogue_data = {}  #Static Options data
#Dynamic Dictionaries 
var formation_stats = {} #Same as Global.dict_formation_stats
var enemy_stats = {}   #Same as Global.dict_enemy_stats 
var inven_data = {}  #Same as Global.dict_player_inventory - Should be empty when starting a new game - has no direct import file
var shop_inven = {} #Same as Global.dict_shop_inventory (keeps track of the count of any items that are limited in the shops)
var character_stats = {} #Same as Global.dict_character_stats
var quest_stats = {}  #Same as Global.dict_quest_stats
var options_stats = {} #Same as Global.dct_options_stats

func _ready():
	inven_data.clear()
	Global.dict_player_inventory.clear()
	Global.dict_player_inventory = inven_data
	
	
	var itemdata_file = File.new()
	itemdata_file.open("res://Data/ItemTable - Sheet1.json", File.READ)
	var itemdata_json = JSON.parse(itemdata_file.get_as_text())
	itemdata_file.close()
	item_data = itemdata_json.result


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
