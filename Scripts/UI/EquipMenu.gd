extends Control
signal menu_closed


onready var item  : PackedScene = load("res://Scenes/UI/ItemDisplay.tscn")
onready var itemdetail  : PackedScene = load("res://Scenes/UI/Stat_Detail.tscn")
onready var inventory : PackedScene = load("res://Scenes/UI/InventoryMenu.tscn")

#onready var menuroot = get_node(".")

onready var rhweaponhbox = $FullMenu/TabsContainer/EquipSlots/RightVBox/RHWeaponHBox
onready var armorhbox = $FullMenu/TabsContainer/EquipSlots/LeftVBox/ArmorHBox
onready var shoeshbox = $FullMenu/TabsContainer/EquipSlots/LeftVBox/ShoesHBox
onready var rhweapon_item_button = $FullMenu/TabsContainer/EquipSlots/RightVBox/RHWeaponHBox/ItemBackground/ItemButton
onready var armor_item_button = $FullMenu/TabsContainer/EquipSlots/LeftVBox/ArmorHBox/ItemBackground/ItemButton
onready var shoes_item_button = $FullMenu/TabsContainer/EquipSlots/LeftVBox/ShoesHBox/ItemBackground/ItemButton


onready var equipped_item_name = $FullMenu/TabsContainer/EquipDetail/Item_Inspector_Container/ItemName
onready var equipped_item_description = $FullMenu/TabsContainer/EquipDetail/Item_Inspector_Container/ScrollContainer/ItemDescription
onready var equipped_item_stats = $FullMenu/TabsContainer/EquipDetail/Item_Inspector_Container/ItemStats/StatsContainer/Stats

onready var charname = $FullMenu/Header/CharName

var get_item_type 
var container
var stats
var statarray = ["Attack", "Defense","Speed", "Sell Value"] #stats to display (assuming the stat is not 0)
var drop_item_name
var dict_formation = ImportData.formation_stats
var dict_char = ImportData.character_stats
var dict_items = ImportData.item_data
var dict_inven = ImportData.inven_data
var armor = ""
var shoes = ""
var rhweapon = ""
var char_name
var item_type
var char_selected

func _ready():

	for n in range(dict_formation.size()):
		char_name = dict_formation.keys()[n]
		var char_form_num = int(dict_formation[char_name]["FormationNumber"])
		var char_in_party = dict_formation[char_name]["InParty"]
		match char_form_num:
			1:
				if char_in_party == "Yes":
					$FullMenu/TabsContainer/CharacterPanel/Char1/Char1Button.disabled = false
					$FullMenu/TabsContainer/CharacterPanel/Char1/Label.set_text(char_name)
			2:
				if char_in_party == "Yes":
					$FullMenu/TabsContainer/CharacterPanel/Char2/Char2Button.disabled = false
					$FullMenu/TabsContainer/CharacterPanel/Char2/Label.set_text(char_name)
			3:
				if char_in_party == "Yes":
					$FullMenu/TabsContainer/CharacterPanel/Char3/Char3Button.disabled = false
					$FullMenu/TabsContainer/CharacterPanel/Char3/Label.set_text(char_name)
			4:
				if char_in_party == "Yes":
					$FullMenu/TabsContainer/CharacterPanel/Char4/Char4Button.disabled = false
					$FullMenu/TabsContainer/CharacterPanel/Char4/Label.set_text(char_name)
	_on_Char1_button_up()


func get_inventory_type():
	var dict = ImportData.inven_data
	for i in range(0, dict.size()):
		var item_name = dict.keys()[i]
		var dict_item_values = ImportData.item_data
		item_type = dict_item_values[item_name]["Type"]
		var scene_instance = item.instance()
		var icon = "res://Icons/" + str(item_name) + ".png"
		var iconpressed = "res://Icons/" + str(item_name) + "Pressed" + ".png"
		scene_instance.set_name(item_name)
		container.add_child(scene_instance)
		scene_instance.get_node("ItemName").set_text(item_name)
		scene_instance.get_node("ItemBackground/ItemButton").set_normal_texture(load(icon))
		scene_instance.get_node("ItemBackground/ItemButton").set_pressed_texture(load(iconpressed))

		i += 1

func _on_ExitButton_button_up():
	emit_signal("menu_closed")
	queue_free()


func _on_ItemDisplay_get_item_info(name):
	clear_item_detail()
	stats = equipped_item_stats
	var dict_item_values = ImportData.item_data
	var test_array = dict_item_values[name]

	equipped_item_name.set_text(name)
	equipped_item_description.set_text(test_array["Description"])
	for i in range(test_array.size()):
#
		var stat_name = test_array.keys()[i]
		var stat_value = test_array[stat_name]
		var scene_instance = itemdetail.instance()
		if statarray.has(stat_name):
			if stat_value != 0:
				scene_instance.set_name(name)
				stats.add_child(scene_instance)
#
				var statname = scene_instance.get_node("StatName")
				var statvalue = scene_instance.get_node("StatValue")
#
				statname.set_text(stat_name)
				statvalue.set_text(str(stat_value))
		i -= 1
	$FullMenu/TabsContainer/EquipDetail/Item_Inspector_Container/HBoxContainer/UnequipButton.visible = true
	$FullMenu/TabsContainer/EquipDetail/Item_Inspector_Container/HBoxContainer/SwapButton.visible = true
#

#
func clear_item_detail():
	$FullMenu/TabsContainer/EquipDetail/Item_Inspector_Container/ItemType.set_text("")
	equipped_item_name.set_text("")
	equipped_item_description.set_text("")
	var parent = equipped_item_stats
	if parent != null:
		for n in parent.get_children():
			parent.remove_child(n)
	$FullMenu/TabsContainer/EquipDetail/Item_Inspector_Container/HBoxContainer/UnequipButton.visible = false
	$FullMenu/TabsContainer/EquipDetail/Item_Inspector_Container/HBoxContainer/SwapButton.visible = false
	item_type = ""


func _on_swapButton_button_up():
	var invscene = inventory.instance()
	get_parent().add_child(invscene)
	invscene.connect("nav_to_equip", self, "_on_EquipMenu_focus_entered")
	match item_type:
		"Weapons":
			invscene._on_Weapons_button_up()
		"Armor":
			invscene._on_Armor_button_up()
		"Shoes":
			invscene._on_Shoes_button_up()
	#clear # after adding Shoes tab to inventory menu


func _on_unequpButton_button_up():
	if dict_char[char_name][item_type + "Equipped"] == null or dict_char[char_name][item_type + "Equipped"] == "Fist":
		pass
	else:
		var curr_equipped_item = dict_char[char_name][item_type + "Equipped"] 
		dict_inven[curr_equipped_item][1] += 1
		dict_char[char_name][item_type + "Equipped"] = null
		if item_type == "Weapons":
			dict_char[char_name][item_type + "Equipped"] = "Fist"
		clear_item_detail()
		_on_EquipMenu_focus_entered()
		



func _on_WeaponButton_button_up():
	item_type = "Weapons"
	if dict_char[char_name][item_type + "Equipped"] != null:
		name = dict_char[char_name][item_type + "Equipped"]
		_on_ItemDisplay_get_item_info(name)
	else:
		clear_item_detail()
		$FullMenu/TabsContainer/EquipDetail/Item_Inspector_Container/HBoxContainer/SwapButton.visible = true
	item_type = "Weapons"
	$FullMenu/TabsContainer/EquipDetail/Item_Inspector_Container/ItemType.set_text(item_type)

func _on_ArmorButton_button_up():

	item_type = "Armor"
	if dict_char[char_name][item_type + "Equipped"] != null:
		name = dict_char[char_name][item_type + "Equipped"]
		_on_ItemDisplay_get_item_info(name)
	else:
		clear_item_detail()
		$FullMenu/TabsContainer/EquipDetail/Item_Inspector_Container/HBoxContainer/SwapButton.visible = true
	item_type = "Armor"
	$FullMenu/TabsContainer/EquipDetail/Item_Inspector_Container/ItemType.set_text(item_type)


func _on_ShoesButton_button_up():
	item_type = "Shoes"
	if dict_char[char_name][item_type + "Equipped"] != null:
		name = dict_char[char_name][item_type + "Equipped"]
		_on_ItemDisplay_get_item_info(name)
	else:
		clear_item_detail()
		$FullMenu/TabsContainer/EquipDetail/Item_Inspector_Container/HBoxContainer/SwapButton.visible = true
	item_type = "Shoes"
	$FullMenu/TabsContainer/EquipDetail/Item_Inspector_Container/ItemType.set_text(item_type)



func _on_EquipMenu_focus_entered():
	var curr_item_type = item_type
	var curr_char = char_selected
	_ready()
	match curr_char:
		"Char1":
			_on_Char1_button_up()
		"Char2":
			_on_Char2_button_up()
		"Char3":
			_on_Char3_button_up()
		"Char4":
			_on_Char4_button_up()
		null:
			pass

	match curr_item_type:
		"Weapons":
			_on_WeaponButton_button_up()
		"Armor":
			_on_ArmorButton_button_up()
		"Shoes":
			_on_ShoesButton_button_up()
		null:
			pass

func set_equipped_data():
	charname.set_text(char_name)
	rhweapon = dict_char[char_name]["WeaponsEquipped"]
	armor = dict_char[char_name]["ArmorEquipped"]
	shoes = dict_char[char_name]["ShoesEquipped"]
	var weapon_icon = "res://Icons/" + str(rhweapon) + ".png"
	var weapon_iconpressed = "res://Icons/" + str(rhweapon) + "Pressed" + ".png"
	var armor_icon = "res://Icons/" + str(armor) + ".png"
	var armor_iconpressed = "res://Icons/" + str(armor) + "Pressed" + ".png"
	var shoes_icon = "res://Icons/" + str(shoes) + ".png"
	var shoes_iconpressed = "res://Icons/" + str(shoes) + "Pressed" + ".png"
	
	if weapon_icon != "res://Icons/Null.png":
		rhweapon_item_button.set_normal_texture(load(weapon_icon))
		rhweapon_item_button.set_pressed_texture(load(weapon_iconpressed))
	else: 
		rhweapon_item_button.set_normal_texture(null)
		rhweapon_item_button.set_pressed_texture(null)
		
	if armor_icon != "res://Icons/Null.png":
		armor_item_button.set_normal_texture(load(armor_icon))
		armor_item_button.set_pressed_texture(load(armor_iconpressed))
	else: 
		armor_item_button.set_normal_texture(null)
		armor_item_button.set_pressed_texture(null)
	
	if shoes_icon != "res://Icons/Null.png":
		shoes_item_button.set_normal_texture(load(shoes_icon))
		shoes_item_button.set_pressed_texture(load(shoes_iconpressed))
	else: 
		shoes_item_button.set_normal_texture(null)
		shoes_item_button.set_pressed_texture(null)



func _on_Char1_button_up():
	char_selected = "Char1"
	char_name = $FullMenu/TabsContainer/CharacterPanel/Char1/Label.get_text()
	set_equipped_data()
	clear_item_detail()

func _on_Char2_button_up():
	char_selected = "Char2"
	char_name = $FullMenu/TabsContainer/CharacterPanel/Char2/Label.get_text()
	set_equipped_data()
	clear_item_detail()


func _on_Char3_button_up():
	char_selected = "Char3"
	char_name = $FullMenu/TabsContainer/CharacterPanel/Char3/Label.get_text()
	set_equipped_data()
	clear_item_detail()


func _on_Char4_button_up():
	char_selected = "Char4"
	char_name = $FullMenu/TabsContainer/CharacterPanel/Char4/Label.get_text()
	set_equipped_data()
	clear_item_detail()
