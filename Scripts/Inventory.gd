extends Node




onready var item  : PackedScene = load("res://Scenes/Buttons/Item_Button.tscn")
onready var equipment  : PackedScene = load("res://Scenes/Buttons/Equipment_Button.tscn")

func _ready():
	var inventory_list = get_node("ItemContainer/ItemList")
	var _itemlabel = get_node("ItemContainer/ItemList/Label")
	
	var equipment_list = get_node("EquipmentConainer/EquipmentList")
	var _equipmentlabel = get_node("EquipmentConainer/EquipmentList/Label")
	
#load List of items in inventory
	for i in range(0, Global.dict_items.size()):

		var item_name = Global.dict_items.keys()[i]
		var item_count = Global.dict_items.values()[i]
		var scene_instance = item.instance()
		scene_instance.set_name(item_name)
		if item_count != 0: 
#			inventory_list.add_child_below_node(itemlabel, scene_instance)
			inventory_list.add_child(scene_instance)
			scene_instance.get_node("Item_Button").set_text(item_name)
			scene_instance.get_node("Label").set_text(String(item_count))
		i += 1


#Load list of equipment in inventory
	for i in range(0, Global.dict_equipment.size()):

		var equip_name = Global.dict_equipment.keys()[i]
		var equip_count = Global.dict_equipment.values()[i]
		var scene_instance = equipment.instance()
		scene_instance.set_name(equip_name)
		if equip_count != 0:
			equipment_list.add_child(scene_instance)
			scene_instance.get_node("Equipment_Button").set_text(equip_name)
			scene_instance.get_node("Label").set_text(String(equip_count))
		i += 1




