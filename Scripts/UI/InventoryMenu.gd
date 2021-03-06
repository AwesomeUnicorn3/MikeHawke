extends Control
signal menu_closed
signal nav_to_equip

onready var char_select : PackedScene = load("res://Scenes/UI/CharacterSelect.tscn")
onready var slot_select : PackedScene = load("res://Scenes/UI/SlotSelect.tscn")
onready var item  : PackedScene = load("res://Scenes/UI/ItemDisplay.tscn")
onready var itemdetail  : PackedScene = load("res://Scenes/UI/Stat_Detail.tscn")
onready var dropconfirm : PackedScene = load("res://Scenes/UI/DropConfirm.tscn")
#onready var equipmenu : PackedScene = load("res://Scenes/UI/EquipMenu.tscn")
onready var menuroot = get_node(".")

onready var currency = $FullMenu/TabsContainer/CategoryPanel/Currency/Currency/CurrencyDisplay
onready var weapons = $FullMenu/TabsContainer/Weapons
onready var armor = $FullMenu/TabsContainer/Armor
onready var skill = $FullMenu/TabsContainer/Skills
onready var consumable = $FullMenu/TabsContainer/Consumable
onready var quest_items = get_node("FullMenu/TabsContainer/Quest Items")

onready var weapons_button = $FullMenu/TabsContainer/CategoryPanel/Weapons/Button
onready var armor_button = $FullMenu/TabsContainer/CategoryPanel/Armor/Button
onready var skill_button = $FullMenu/TabsContainer/CategoryPanel/Skills/Button
onready var consumable_button = $FullMenu/TabsContainer/CategoryPanel/Consumable/Button
onready var quest_items_button = get_node("FullMenu/TabsContainer/CategoryPanel/Quest Items/Button")

onready var  weapons_container = $FullMenu/TabsContainer/Weapons/VBoxContainer
onready var  armor_container = $FullMenu/TabsContainer/Armor/VBoxContainer
onready var  skill_container = $FullMenu/TabsContainer/Skills/VBoxContainer
onready var  consumable_container = $FullMenu/TabsContainer/Consumable/VBoxContainer
onready var  quest_items_container = get_node("FullMenu/TabsContainer/Quest Items/VBoxContainer")

onready var item_inspector_container = $FullMenu/TabsContainer/ItemInspector/Item_Inspector_Container
onready var item_detail_container = $FullMenu/TabsContainer/ItemInspector/Item_Inspector_Container/ItemStats/StatsContainer/Stats
onready var item_name_container = $FullMenu/TabsContainer/ItemInspector/Item_Inspector_Container/ItemName
onready var item_Description_container = $FullMenu/TabsContainer/ItemInspector/Item_Inspector_Container/ItemDescription
var equiptype
var itemdrop
var get_item_type 
var container
var stats
var statarray = ["Attack", "Defense","Speed", "Sell Value"] #stats to display (assuming the stat is not 0)
var drop_item_name
var dict_formation = ImportData.formation_stats
var dict_char = ImportData.character_stats
var dict_inven = ImportData.inven_data
var dict_item = ImportData.item_data
var dict_options = ImportData.options_stats
var selected_char
var char_selected = false
var parent = "Inventory"
func _ready():
	
	if ImportData.inven_data.has(Global.currency):
		currency.set_text(String(ImportData.inven_data[Global.currency][1]))
	else:
		currency.set_text(String(0))
	get_node("FullMenu/TabsContainer/CategoryPanel/Weapons/Button").grab_focus()


func close_all_tabs():
	var array = [weapons_container, armor_container, skill_container, consumable_container, quest_items_container]
	for i in range(0, array.size()):
		var parent = array[i]
		for n in parent.get_children():
			parent.remove_child(n)
			n.queue_free()
	
	
	weapons.visible = false
	armor.visible = false
	skill.visible = false
	consumable.visible = false
	quest_items.visible = false
	
	weapons_button.disabled = false
	armor_button.disabled = false
	skill_button.disabled = false
	consumable_button.disabled = false
	quest_items_button.disabled = false

func get_inventory_type():
	var dict = ImportData.inven_data
	for i in range(0, dict.size()):
		#get item type
		
		var item_name = dict.keys()[i]
		var item_count = dict.values()[i][1]
		var dict_item_values = ImportData.item_data
		var item_type = dict_item_values[item_name]["Type"]
		var scene_instance = item.instance()
		var icon = "res://Icons/" + str(item_name) + ".png"
		scene_instance.set_name(item_name)
		if item_count != 0: 
			if item_type != get_item_type:
				pass
			else:

				
				scene_instance.connect("get_item_info", self, "_on_ItemDisplay_get_item_info")
				scene_instance.connect("drop_selected", self, "_on_DropButton_button_up")
				scene_instance.connect("equip_item", self, "equip_selected_item")
				scene_instance.get_node("ItemDisplay/ItemName").set_text(item_name)
				scene_instance.parent = get_name()
				scene_instance.get_node("ItemDisplay/ItemBackground/ItemButton/Label").set_text(String(item_count))
				scene_instance.get_node("ItemDisplay/ItemBackground/ItemButton").set_normal_texture(load(icon))
				container.add_child(scene_instance)
		i += 1

func _on_ExitButton_button_up():

	clear_item_detail()
	emit_signal("menu_closed")
	emit_signal("nav_to_equip")
	queue_free()


func _on_Weapons_button_up():
	close_all_tabs()
	weapons.visible = true
	weapons_button.disabled = true
	get_item_type = "Weapons"
	container = weapons_container
	get_inventory_type()
	clear_item_detail()

func _on_Armor_button_up():
	close_all_tabs()
	armor.visible = true
	armor_button.disabled = true
	get_item_type = "Armor"
	container = armor_container
	get_inventory_type()
	clear_item_detail()


#func _on_Shoes_button_up():
#	close_all_tabs()
#	shoes.visible = true
#	shoes_button.disabled = true
#	get_item_type = "Shoes"
#	container = shoes_container
#	get_inventory_type()
#	clear_item_detail()


func _on_Skills_button_up():
	close_all_tabs()
	skill.visible = true
	skill_button.disabled = true
	get_item_type = "Skills"
	container = skill_container
	get_inventory_type()
	clear_item_detail()

func _on_Consumable_button_up():
	close_all_tabs()
	consumable.visible = true
	consumable_button.disabled = true
	get_item_type = "Consumable"
	container = consumable_container
	get_inventory_type()
	clear_item_detail()

func _on_Quest_Items_button_up():
	close_all_tabs()
	quest_items.visible = true
	quest_items_button.disabled = true
	get_item_type = "Quest Items"
	container = quest_items_container
	get_inventory_type()
	clear_item_detail()

func _on_ItemDisplay_get_item_info(name):
	clear_item_detail()
	stats = item_detail_container
	var dict_item_values = ImportData.item_data
	var test_array = dict_item_values[name]


	item_name_container.set_text(name)
	item_Description_container.set_text(test_array["Description"])
	for i in range(test_array.size()):

		var stat_name = test_array.keys()[i]
		var stat_value = test_array[stat_name]
		var scene_instance = itemdetail.instance()
		if statarray.has(stat_name):
			if stat_value != 0:
				scene_instance.set_name(name)
				stats.add_child(scene_instance)
				
				var statname = scene_instance.get_node("StatName")
				var statvalue = scene_instance.get_node("StatValue")
		
				statname.set_text(stat_name)
				statvalue.set_text(str(stat_value))
		i -= 1


func _on_DropButton_button_up(count, itemdrops, _item_price, _cost, _shopcount):
	$FullMenu.visible = false
	var maxdrop = int(count)
	var scene_instance = dropconfirm.instance()
	menuroot.add_child(scene_instance)
	scene_instance.get_node("DropPanelContainer/MainNodes/SpinBox").set_max(maxdrop)
	scene_instance.get_node("ItemName").set_text(itemdrops)
	scene_instance.connect("refresh_inventory", self, "_on_drop_refresh")

func _on_drop_refresh():
	match get_item_type:
		"Weapons":
			_on_Weapons_button_up()
		"Armor":
			_on_Armor_button_up()
#		"Shoes":
#			_on_Shoes_button_up()
		"Skills":
			_on_Skills_button_up()
		"Consumable":
			_on_Consumable_button_up()
		"Quest_Items":
			_on_Quest_Items_button_up()

func clear_item_detail():
	item_name_container.set_text("")
	item_Description_container.set_text("")
	var parent2 = item_detail_container
	if parent2 != null:
		for n in parent2.get_children():
			parent2.remove_child(n)

func equip_selected_item(itemdrops):
	$FullMenu.visible = false
	itemdrop = itemdrops
	equiptype = dict_item[itemdrop]["Type"]
	var t = char_select.instance()
	#add popup to signal player to select which character to equip item to
	menuroot.add_child(t)
	t.connect("selected", self, "_on_char_selected")
	yield(t,"exit")
	if equiptype != "Weapons" and equiptype != "Armor" and char_selected != false:
#	and char_name != null:
		var y = slot_select.instance()
		menuroot.add_child(y)
		$FullMenu.visible = false
		y.connect("selected", self, "_on_slot_selected")
		yield(y,"exit")
	$FullMenu.visible = true
	char_selected = false
#	$FullMenu/Header/Exit/ExitButton.disabled = false

func _on_char_selected(char_name):
	char_selected = true
	$FullMenu.visible = false
	if equiptype != "Weapons" and equiptype != "Armor":
		selected_char = char_name
	else:
		
		var name = char_name + " " + equiptype
	#this is where you unequip item, add to inventory, equip item, remove from inventory
		var curr_equipped_item = dict_options[name]["equipped_item"]
		curr_equipped_item = itemdrop
		if curr_equipped_item != null and curr_equipped_item != "Fist":
			dict_inven[itemdrop][1] -= 1
			dict_options[name]["equipped_item"] = curr_equipped_item
		_on_drop_refresh()


func _on_slot_selected(slot_name):
	char_selected = true
	var selected = selected_char + " " + slot_name
	dict_inven[itemdrop][1] -= 1
	dict_options[selected]["equipped_item"] = itemdrop
	#equip item to selected slot for selected character
	_on_drop_refresh()
