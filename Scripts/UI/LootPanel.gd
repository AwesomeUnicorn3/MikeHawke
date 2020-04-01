extends Control

signal closed
var map_name
var loot_count
var loot_dict = {}


func _ready():
#	Global.load_scene = "res://Scenes/Fruitville.tscn" #Delete after testing
	map_name = String(Global.Dict_locations[Global.load_scene])
#	Loot_Generate()

func Loot_Generate():
	DetermineLootCount()
	LootSelector()
	PopulatePanel()
	
	
func DetermineLootCount():
	var ItemCountMin = ImportData.loot_data[map_name].ItemCountMin
	var ItemCountMax = ImportData.loot_data[map_name].ItemCountMax
	randomize()
	loot_count = randi() % ((int(ItemCountMax) - int(ItemCountMin)) + 1) + int(ItemCountMin)
#	print(loot_count)


func static_loot(item, itemcount):
	var loot = []
	loot.append(item)
	loot.append(itemcount)
	loot_dict[loot_dict.size() + 1] = loot
	PopulatePanel()



func LootSelector():
	for _i in range(1, loot_count + 1):
		randomize()
		var loot_selector = randi() % 100 + 1
		var counter = 1
		while loot_selector >= 0:
			if loot_selector <= ImportData.loot_data[map_name]["Item" + str(counter)+ "Chance"]:
				var loot = []
				loot.append(ImportData.loot_data[map_name]["Item" + str(counter)+ "Name"])
				randomize()
				loot.append((int(rand_range(float(ImportData.loot_data[map_name]["Item" + str(counter) + "MinQ"]), float(ImportData.loot_data[map_name]["Item" + str(counter) + "MaxQ"])))))
				loot_dict[loot_dict.size() + 1] = loot
				break
			else:
				loot_selector = loot_selector - ImportData.loot_data[map_name]["Item" + str(counter) + "Chance"]
				counter += 1
#	print(loot_dict)


func PopulatePanel():

	var counter = 1
	for i in get_tree().get_nodes_in_group("LootPanelSlots"):
		if counter < loot_dict.size() + 1:
				
			get_node(str(i.get_path()) + "/ItemName").set_text(loot_dict[counter][0])
			var icon = "res://Icons/" + str(loot_dict[counter][0]) + ".png"
			var iconpressed = "res://Icons/" + str(loot_dict[counter][0]) + "Pressed" + ".png"
			get_node(str(i.get_path()) + "/ItemBackground/ItemButton").set_normal_texture(load(icon))
			get_node(str(i.get_path()) + "/ItemBackground/ItemButton").set_pressed_texture(load(iconpressed))
			if loot_dict[counter][1] > 1:
				get_node(str(i.get_path()) + "/ItemBackground/ItemButton/Label").set_text(str(loot_dict[counter][1]))
			counter += 1

func PopulatePanel_text():
	var counter = 1
	var counterstring = str(counter)
#	print(counter)
	for i in get_tree().get_nodes_in_group("LootPanelSlots"):
		if counter < loot_dict.size() + 1:
			get_node(str(i.get_path()) + "/ItemName").set_text(loot_dict[counterstring][0])
			var icon = "res://Icons/" + str(loot_dict[counterstring][0]) + ".png"
			var iconpressed = "res://Icons/" + str(loot_dict[counterstring][0]) + "Pressed" + ".png"
			get_node(str(i.get_path()) + "/ItemBackground/ItemButton").set_normal_texture(load(icon))
			get_node(str(i.get_path()) + "/ItemBackground/ItemButton").set_pressed_texture(load(iconpressed))
			if loot_dict[counterstring][1] > 1:
				get_node(str(i.get_path()) + "/ItemBackground/ItemButton/Label").set_text(str(loot_dict[counterstring][1]))
			counter += 1
			counterstring = str(counter)

func _on_CloseButton_button_up():
	emit_signal("closed")



func _on_ItemButton_button_up(lootpanelslot):
	var text = ImportData.importtext
	var Currency = Global.currency
	var lpstext = str(lootpanelslot)
	
	
	if text == true:
		
		if loot_dict.has(lpstext):
			var looted_item_name_text = str(loot_dict[lootpanelslot][0])
			if not ImportData.inven_data.has(loot_dict[lpstext][0]):
				ImportData.inven_data[loot_dict[lpstext][0]] = [loot_dict[lpstext][0], 0]
			if looted_item_name_text == Currency:
				ImportData.inven_data[Currency][1] += loot_dict[lpstext][1]
			else:
				var data = loot_dict[lpstext][0]
				ImportData.inven_data[data][1] += loot_dict[lpstext][1]
			loot_dict.erase(lpstext)
			var loot_slot_root = "LootPanelConainer/MainNodes/Items/ItemsContainer/Loot" + lpstext
			get_node(loot_slot_root + "/ItemBackground/ItemButton").set_normal_texture(null)
			get_node(loot_slot_root + "/ItemBackground/ItemButton").set_pressed_texture(null)
			get_node(loot_slot_root + "/ItemBackground/ItemButton/Label").set_text("")
			get_node(loot_slot_root + "/ItemName").set_text("")
		#erase - follow tutorial for this part
		
		
		
		
	else:		
		
		if loot_dict.has(lootpanelslot):
			var looted_item_name = loot_dict[lootpanelslot][0]
			if not ImportData.inven_data.has(loot_dict[lootpanelslot][0]):
				ImportData.inven_data[loot_dict[lootpanelslot][0]] = [loot_dict[lootpanelslot][0], 0]
			if looted_item_name == Currency:
				ImportData.inven_data[Currency][1] += loot_dict[lootpanelslot][1]
			else:
				var data = loot_dict[lootpanelslot][0]
				ImportData.inven_data[data][1] += loot_dict[lootpanelslot][1]
			loot_dict.erase(lootpanelslot)
			var loot_slot_root = "LootPanelConainer/MainNodes/Items/ItemsContainer/Loot" + lpstext
			get_node(loot_slot_root + "/ItemBackground/ItemButton").set_normal_texture(null)
			get_node(loot_slot_root + "/ItemBackground/ItemButton").set_pressed_texture(null)
			get_node(loot_slot_root + "/ItemBackground/ItemButton/Label").set_text("")
			get_node(loot_slot_root + "/ItemName").set_text("")
#	print(ImportData.inven_data)

func _on_LootAllButton_button_up():
	for lootpanelslot in range(1,7):
		_on_ItemButton_button_up(lootpanelslot)
	_on_CloseButton_button_up()
