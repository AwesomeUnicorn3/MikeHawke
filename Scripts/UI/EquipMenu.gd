extends Control
signal menu_closed


#onready var item  : PackedScene = load("res://Scenes/UI/ItemDisplay.tscn")
onready var itemdetail  : PackedScene = load("res://Scenes/UI/Stat_Detail.tscn")
onready var inventory : PackedScene = load("res://Scenes/UI/InventoryMenu.tscn")
onready var quick_access : PackedScene = load("res://Scenes/UI/Equip_Detail.tscn")


onready var equip_detail = $FullMenu/TabsContainer/EquipSlots/LeftVBox/Equip_Detail
onready var equip_detail2 = $FullMenu/TabsContainer/EquipSlots/LeftVBox2/Equip_Detail
onready var equipped_item_name = $FullMenu/TabsContainer/EquipDetail/Item_Inspector_Container/ItemName
onready var equipped_item_description = $FullMenu/TabsContainer/EquipDetail/Item_Inspector_Container/ScrollContainer/ItemDescription
onready var equipped_item_stats = $FullMenu/TabsContainer/EquipDetail/Item_Inspector_Container/ItemStats/StatsContainer/Stats
onready var charname = $FullMenu/Header/CharName

var get_item_type 
var container
var stats
var button_list = ["weapon", "defense", "slot 1", "slot 2", "slot 3", "slot 4"]
var statarray = ["Attack", "Defense","Speed", "Sell Value"] #stats to display (assuming the stat is not 0)
var drop_item_name
var dict_formation = ImportData.formation_stats
var dict_char = ImportData.character_stats
var dict_items = ImportData.item_data
var dict_inven = ImportData.inven_data
var dict_op = ImportData.options_stats
var armor = ""
var shoes = ""
var rhweapon = ""
var char_letter
var item_type
var char_selected
var char_name
var slot_name
var options_name


func _ready():
	Global.equip_menu_type = "EquipMenu"
	for n in range(dict_formation.size()):
		char_name = dict_formation.keys()[n]
		char_letter = int(dict_formation[char_name]["FormationNumber"]) #formation number
		var char_in_party = dict_formation[char_name]["InParty"]
		match char_letter:
			1:
				if char_in_party == "Yes":
					$FullMenu/TabsContainer/CharacterPanel/Char1/Char1Button.disabled = false
					$FullMenu/TabsContainer/CharacterPanel/Char1/Label.set_text(char_name)
			2:
				if char_in_party == "Yes":
					$FullMenu/TabsContainer/CharacterPanel/Char2/Char2Button.disabled = false
					$FullMenu/TabsContainer/CharacterPanel/Char2/Label.set_text(char_name)
					$FullMenu/TabsContainer/CharacterPanel/Char2.visible = true
			3:
				if char_in_party == "Yes":
					$FullMenu/TabsContainer/CharacterPanel/Char3/Char3Button.disabled = false
					$FullMenu/TabsContainer/CharacterPanel/Char3/Label.set_text(char_name)
					$FullMenu/TabsContainer/CharacterPanel/Char3.visible = true
			4:
				if char_in_party == "Yes":
					$FullMenu/TabsContainer/CharacterPanel/Char4/Char4Button.disabled = false
					$FullMenu/TabsContainer/CharacterPanel/Char4/Label.set_text(char_name)
					$FullMenu/TabsContainer/CharacterPanel/Char4.visible = true
	_on_Char1_button_up()


#func get_inventory_type():
#	var dict = ImportData.inven_data
#	for i in range(0, dict.size()):
#		var item_name = dict.keys()[i]
#		var dict_item_values = ImportData.item_data
#
#		var scene_instance = item.instance()
#		var icon = "res://Icons/" + str(item_name) + ".png"
#		var iconpressed = "res://Icons/" + str(item_name) + "Pressed" + ".png"
#		scene_instance.set_name(item_name)
#		container.add_child(scene_instance)
#		scene_instance.get_node("ItemName").set_text(item_name)
#		scene_instance.get_node("ItemBackground/ItemButton").set_normal_texture(load(icon))
#		scene_instance.get_node("ItemBackground/ItemButton").set_pressed_texture(load(iconpressed))
#
#		i += 1

func _on_ExitButton_button_up():
	Global.equip_menu_type = "GUI"
#	Global.refresh_gui()
	emit_signal("menu_closed")
	queue_free()


func _on_ItemDisplay_get_item_info(name):
	clear_item_detail()
	stats = equipped_item_stats
	var dict_item_values = ImportData.item_data
	if name != "Empty":
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
	$FullMenu/TabsContainer/EquipDetail/Item_Inspector_Container/HBoxContainer/SwapButton/swapButton.disabled = false
	$FullMenu/TabsContainer/EquipDetail/Item_Inspector_Container/HBoxContainer/UnequipButton/unequpButton.disabled = false


func clear_item_detail():
	$FullMenu/TabsContainer/EquipDetail/Item_Inspector_Container/ItemType.set_text("")
	equipped_item_name.set_text("")
	equipped_item_description.set_text("")
	var parent = equipped_item_stats
	if parent != null:
		for n in parent.get_children():
			parent.remove_child(n)
			pass
	$FullMenu/TabsContainer/EquipDetail/Item_Inspector_Container/HBoxContainer/SwapButton/swapButton.disabled = true
	$FullMenu/TabsContainer/EquipDetail/Item_Inspector_Container/HBoxContainer/UnequipButton/unequpButton.disabled = true
#	item_type = ""

func clear_slot_detail():
	var parent = $FullMenu/TabsContainer/EquipSlots/LeftVBox
	if parent != null:
		for n in parent.get_children():
			if n == equip_detail:
				pass
			else:
#				print(n.get_path())
				n.queue_free()
	parent = $FullMenu/TabsContainer/EquipSlots/LeftVBox2
	if parent != null:
		for n in parent.get_children():
			if n == equip_detail2:
				pass
			else:
#				print(n.get_path())
				n.queue_free()



func _on_swapButton_button_up():
	var invscene = inventory.instance()
	get_parent().add_child(invscene)
	invscene.connect("nav_to_equip", self, "_on_EquipMenu_focus_entered")
	match item_type:
		"weapon":
			invscene._on_Weapons_button_up()
		"defense":
			invscene._on_Armor_button_up()
		"slot 1":
			invscene._on_Consumable_button_up()
		"slot 2":
			invscene._on_Consumable_button_up()
		"slot 3":
			invscene._on_Consumable_button_up()
		"slot 4":
			invscene._on_Consumable_button_up()

func _on_unequpButton_button_up():
	var eq_item = dict_op[options_name]["equipped_item"]
	if eq_item == null or eq_item == "Fist" or eq_item == "Empty":
		pass
#		print("success")
	else:
		var dict_item_values = ImportData.item_data
		eq_item = dict_op[options_name]["equipped_item"] 
		item_type = dict_item_values[eq_item]["Type"]
		dict_inven[eq_item][1] += 1
		dict_op[options_name]["equipped_item"]  = "Empty"


		if item_type == "weapon":
			dict_op[options_name]["equipped_item"] = "Fist"
	_on_EquipMenu_focus_entered()


func _on_button_down(slt_name, op_name):
	options_name = op_name
	item_type = slt_name
	if dict_op[options_name]["equipped_item"] != "Empty":
		var name1 = dict_op[options_name]["equipped_item"]
		_on_ItemDisplay_get_item_info(name1)
	else:
		clear_item_detail()
#		clear_slot_detail()
		$FullMenu/TabsContainer/EquipDetail/Item_Inspector_Container/HBoxContainer/SwapButton/swapButton.disabled = false



func _on_EquipMenu_focus_entered():

	_ready()
	match char_selected:
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


func set_equipped_data():

	charname.set_text(char_name)
	
	for i in button_list:
	#set this to create 6 instances of Key_binding slot template, one for each slot type
		slot_name = i
		var scene_instance = quick_access.instance()
		scene_instance.get_node("Panel/Key_Binding_slot_template/Key_Binding_VBox/slot_name").set_text(i)
		if i == "weapon" or i == "defense":
			$FullMenu/TabsContainer/EquipSlots/LeftVBox.add_child(scene_instance)
		else:
			$FullMenu/TabsContainer/EquipSlots/LeftVBox2.add_child(scene_instance)

func _on_Char1_button_up():
	clear_item_detail()
	clear_slot_detail()
	char_selected = "Char1"
	char_letter = "1"
	char_name = $FullMenu/TabsContainer/CharacterPanel/Char1/Label.get_text()
	set_equipped_data()


func _on_Char2_button_up():
	clear_item_detail()
	clear_slot_detail()
	char_selected = "Char2"
	char_letter = "2"
	char_name = $FullMenu/TabsContainer/CharacterPanel/Char2/Label.get_text()
	set_equipped_data()



func _on_Char3_button_up():
	clear_item_detail()
	clear_slot_detail()
	char_selected = "Char3"
	char_letter = "3"
	char_name  = $FullMenu/TabsContainer/CharacterPanel/Char3/Label.get_text()
	set_equipped_data()



func _on_Char4_button_up():
	clear_item_detail()
	clear_slot_detail()
	char_selected = "Char4"
	char_letter = "4"
	char_name  = $FullMenu/TabsContainer/CharacterPanel/Char4/Label.get_text()
	set_equipped_data()

