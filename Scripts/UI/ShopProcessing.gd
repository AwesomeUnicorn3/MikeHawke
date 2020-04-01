extends Control
signal inventory_closed
#signal drop_menu


onready var item  : PackedScene = load("res://Scenes/UI/ItemDisplay.tscn")
onready var itemdetail  : PackedScene = load("res://Scenes/UI/Stat_Detail.tscn")
onready var sellconfirm : PackedScene = load("res://Scenes/UI/SellConfirm.tscn")
onready var buyconfirm : PackedScene = load("res://Scenes/UI/BuyConfirm.tscn")

onready var menuroot = get_node(".")

onready var currency = $FullMenu/TabsContainer/CategoryPanel/Currency/Currency/CurrencyDisplay
onready var weapons = $FullMenu/TabsContainer/Weapons
onready var armor = $FullMenu/TabsContainer/Armor
onready var crafting = $FullMenu/TabsContainer/Crafting
onready var consumable = $FullMenu/TabsContainer/Consumable
onready var quest_items = $FullMenu/TabsContainer/Quest_Items

onready var weapons_button = $FullMenu/TabsContainer/CategoryPanel/Weapons/TextureButton
onready var armor_button = $FullMenu/TabsContainer/CategoryPanel/Armor/TextureButton
onready var crafting_button = $FullMenu/TabsContainer/CategoryPanel/Crafting/TextureButton
onready var consumable_button = $FullMenu/TabsContainer/CategoryPanel/Consumable/TextureButton
onready var quest_items_button = $FullMenu/TabsContainer/CategoryPanel/Quest_Items/TextureButton

onready var  weapons_container = $FullMenu/TabsContainer/Weapons/VBoxContainer
onready var  armor_container = $FullMenu/TabsContainer/Armor/VBoxContainer
onready var  crafting_container = $FullMenu/TabsContainer/Crafting/VBoxContainer
onready var  consumable_container = $FullMenu/TabsContainer/Consumable/VBoxContainer
onready var  quest_items_container = $FullMenu/TabsContainer/Quest_Items/VBoxContainer

onready var item_inspector_container = $FullMenu/TabsContainer/ItemInspector/Item_Inspector_Container
onready var item_detail_container = $FullMenu/TabsContainer/ItemInspector/Item_Inspector_Container/ItemStats/StatsContainer/Stats
onready var item_name_container = $FullMenu/TabsContainer/ItemInspector/Item_Inspector_Container/ItemName
onready var item_Description_container = $FullMenu/TabsContainer/ItemInspector/Item_Inspector_Container/ItemDescription

onready var sell_button = $FullMenu/Header/Sell/SellButton
onready var buy_button = $FullMenu/Header/Buy/BuyButton


var get_item_type 
var container
var stats
var statarray = ["Attack", "Defense","Speed", "Sell Value", "Cost"] #stats to display (assuming the stat is not 0)
var drop_item_name
var buy_sell_toggle = "Sell"
var dict


func _ready():
	match buy_sell_toggle:
		"Sell":
			buy_button.disabled = false
			sell_button.disabled = true
		"Buy":
			buy_button.disabled = true
			sell_button.disabled = false

	if ImportData.inven_data.has(Global.currency):
		currency.set_text(String(ImportData.inven_data[Global.currency][1]))
	else:
		currency.set_text(String(0))
#	print(Global.shop_name)
	$FullMenu/Header/MenuName.set_text(Global.shop_name)

func close_all_tabs():
	var array = [weapons_container, armor_container, crafting_container, consumable_container, quest_items_container]
	for i in range(0, array.size()):
		var parent = array[i]
		for n in parent.get_children():
			parent.remove_child(n)
			n.queue_free()
	
	
	weapons.visible = false
	armor.visible = false
	crafting.visible = false
	consumable.visible = false
	quest_items.visible = false
	
	weapons_button.disabled = false
	armor_button.disabled = false
	crafting_button.disabled = false
	consumable_button.disabled = false
	quest_items_button.disabled = false

func get_inventory_type():
	var dict_shop_buy = ImportData.shop_inven
	var dict_shop_sell = ImportData.inven_data
	var shop_name = Global.shop_name
	match buy_sell_toggle:
		"Sell":
			Global.buysell = "Sell"
			dict = dict_shop_sell
			for i in range(0, dict.size()):
				var item_name = dict.keys()[i]
				var item_count = dict.values()[i][1]
				var dict_item_values = ImportData.item_data
				var item_type = dict_item_values[item_name]["Type"]
				var can_sell = dict_item_values[item_name]["CanSell"]
				var scene_instance = item.instance()
				var icon = "res://Icons/" + str(item_name) + ".png"
				var iconpressed = "res://Icons/" + str(item_name) + "Pressed" + ".png"
				scene_instance.set_name(item_name)
				if item_count == 0 or item_type != get_item_type or can_sell == "No" : 
					pass
				else:
							
					scene_instance.connect("get_item_info", self, "_on_ItemDisplay_get_item_info")
					scene_instance.connect("drop_selected", self, "_on_DropButton_button_up")
					scene_instance.get_node("ItemName").set_text(item_name)
					scene_instance.get_node("Drop/DropLabel").set_text(buy_sell_toggle)
					scene_instance.get_node("ItemBackground/ItemButton/Label").set_text(String(item_count))
					scene_instance.get_node("ItemBackground/ItemButton").set_normal_texture(load(icon))
					scene_instance.get_node("ItemBackground/ItemButton").set_pressed_texture(load(iconpressed))
					container.add_child(scene_instance)
				i += 1
		"Buy":
			Global.buysell = "Buy"
			dict = dict_shop_buy
#			print(dict)
			for i in range(1, dict[shop_name].size()):
#				print(dict[shop_name])
#				print(dict[shop_name].size())
				var key_name = "Item" + str(i)
				var count_name = key_name + "Count"
				var item_name = dict[shop_name][key_name]
				var item_count = dict[shop_name][count_name]
				if item_name == null:
					break
				var dict_item_values = ImportData.item_data
				var item_type = dict_item_values[item_name]["Type"]
				var scene_instance = item.instance()
				var icon = "res://Icons/" + str(item_name) + ".png"
				var iconpressed = "res://Icons/" + str(item_name) + "Pressed" + ".png"
				scene_instance.set_name(item_name)
				if item_count == null:
					dict[shop_name][count_name] = 10000
					item_count = 10000
				if item_count != 0: 
					if item_type != get_item_type:
						pass
					else:
							
						
						scene_instance.connect("get_item_info", self, "_on_ItemDisplay_get_item_info")
						scene_instance.connect("drop_selected", self, "_on_DropButton_button_up")
						scene_instance.get_node("ItemName").set_text(item_name)
						scene_instance.get_node("Drop/DropLabel").set_text(buy_sell_toggle)
						scene_instance.get_node("ItemNumber").set_text(str(count_name))
						scene_instance.get_node("ItemBackground/ItemButton/Label").set_text(str(item_count))
						scene_instance.get_node("ItemBackground/ItemButton").set_normal_texture(load(icon))
						scene_instance.get_node("ItemBackground/ItemButton").set_pressed_texture(load(iconpressed))
						container.add_child(scene_instance)
# warning-ignore:standalone_expression
				i + 1
	Global.buysell = ""

func _on_ExitButton_button_up():
	Global.Can_walk()
	clear_item_detail()
	emit_signal("inventory_closed")
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

func _on_Crafting_button_up():
	close_all_tabs()
	crafting.visible = true
	crafting_button.disabled = true
	get_item_type = "Crafting"
	container = crafting_container
	get_inventory_type()
	clear_item_detail()

func _on_ConsumableButton_button_up():
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

#	print(test_array)
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


func _on_DropButton_button_up(count, itemdrop, item_price, cost, shopcount):
	match buy_sell_toggle:
		"Sell":
			
			var maxdrop = int(count)
			var scene_instance = sellconfirm.instance()
			menuroot.add_child(scene_instance)
			scene_instance.get_node("DropPanelContainer/MainNodes/SellAmount_Cont/SpinBox").set_max(maxdrop)
			scene_instance.get_node("ItemName").set_text(itemdrop)
			scene_instance.get_node("DropPanelContainer/MainNodes/SellAmount_Cont/item_price_cont/item_price").set_text(String(item_price))
			scene_instance.connect("refresh_inventory", self, "_on_drop_refresh")
			
		
		
		"Buy":
			var maxdrop = int(count)
			var scene_instance = buyconfirm.instance()
			menuroot.add_child(scene_instance)
			scene_instance.get_node("DropPanelContainer/MainNodes/SellAmount_Cont/SpinBox").set_max(maxdrop)
			scene_instance.get_node("ItemName").set_text(itemdrop)
			scene_instance.get_node("ShopName").set_text(Global.shop_name)
			scene_instance.get_node("ItemCost").set_text(str(cost))
			scene_instance.get_node("ShopCount").set_text(str(shopcount))
			scene_instance.get_node("DropPanelContainer/MainNodes/SellAmount_Cont/item_price_cont/item_price").set_text(String(cost))
			scene_instance.connect("refresh_inventory", self, "_on_drop_refresh")

	

func _on_drop_refresh():
	currency.set_text(String(ImportData.inven_data[Global.currency][1]))
	match get_item_type:
		
		"Weapons":
			_on_Weapons_button_up()
		"Armor":
			_on_Armor_button_up()
		"Crafting":
			_on_Crafting_button_up()
		"Consumable":
			_on_ConsumableButton_button_up()
		"Quest Items":
			_on_Quest_Items_button_up()






func clear_item_detail():
	item_name_container.set_text("")
	item_Description_container.set_text("")
	var parent = item_detail_container
	if parent != null:
		for n in parent.get_children():
			parent.remove_child(n)


func _on_Sell_button_up():
	clear_item_detail()
	close_all_tabs()
	sell_button.disabled = true
	buy_button.disabled = false
	buy_sell_toggle = "Sell"


func _on_Buy_button_up():
	clear_item_detail()
	close_all_tabs()
	sell_button.disabled = false
	buy_button.disabled = true
	buy_sell_toggle = "Buy"
